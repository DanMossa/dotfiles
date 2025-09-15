#!/usr/bin/env zsh
# Update Zed settings.json if remote // vN is newer than local // vN

set -u
set -o pipefail

LOCAL_FILE="${HOME}/.config/zed/settings.json"
REMOTE_URL="https://raw.githubusercontent.com/DanMossa/dotfiles/refs/heads/main/zed/settings.json"

# --- helpers ---
extract_version_from_file() {
  # $1: path to file
  # prints the integer after `// v` on the first line, or nothing if missing
  local file="$1"
  local first
  first="$(head -n 1 -- "$file" 2>/dev/null)" || return 1
  print -r -- "$first" | LC_ALL=C sed -nE 's/^[[:space:]]*\/\/[[:space:]]*v([0-9]+).*$/\1/p'
}

msg() { print -r -- "$@"; }
die() { print -ru2 -- "Error: $*"; exit 1; }

# --- fetch remote file to a temp ---
TMP_REMOTE="$(mktemp -t zed_settings_remote.XXXXXX)" || die "Could not create temp file"
cleanup() { rm -f "$TMP_REMOTE" }
trap cleanup EXIT

curl -fsSL "$REMOTE_URL" -o "$TMP_REMOTE" || die "Failed to download remote settings from: $REMOTE_URL"

# --- get versions ---
integer local_ver=0
integer remote_ver=0

if [[ -f "$LOCAL_FILE" ]]; then
  local_v_str="$(extract_version_from_file "$LOCAL_FILE")" || local_v_str=""
  [[ -n "$local_v_str" ]] && local_ver="$local_v_str" || msg "No version tag found in local first line; treating as 0."
else
  msg "Local file not found at $LOCAL_FILE; treating local version as 0."
fi

remote_v_str="$(extract_version_from_file "$TMP_REMOTE")" || remote_v_str=""
[[ -n "$remote_v_str" ]] || die "Remote version tag not found in first line"
remote_ver="$remote_v_str"

# --- echo versions ---
echo "--------------------------------"
echo " Local settings version : $local_ver"
echo " Remote settings version: $remote_ver"
echo "--------------------------------"

# --- compare and replace if newer ---
if (( remote_ver > local_ver )); then
  mkdir -p -- "${LOCAL_FILE:h}" || die "Could not create parent directory for $LOCAL_FILE"

  # Backup local if it exists
  if [[ -f "$LOCAL_FILE" ]]; then
    ts="$(date +%Y%m%d-%H%M%S)"
    backup="${LOCAL_FILE}.${ts}.bak"
    cp -p -- "$LOCAL_FILE" "$backup" || die "Failed to back up local file to $backup"
    msg "Backed up local file to: $backup"
  fi

  # Atomic-ish replace: copy to temp in the same dir, then move
  TMP_LOCAL="$(mktemp -t zed_settings_local.XXXXXX -p "${LOCAL_FILE:h}")" || die "Could not create temp file in ${LOCAL_FILE:h}"
  cp -- "$TMP_REMOTE" "$TMP_LOCAL" || die "Failed to stage new settings"
  mv -f -- "$TMP_LOCAL" "$LOCAL_FILE" || die "Failed to install new settings"

  msg "✅ Updated $LOCAL_FILE to version $remote_ver."
else
  msg "ℹ️ No update needed; local version ($local_ver) is up-to-date."
fi
