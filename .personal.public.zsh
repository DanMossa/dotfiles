# Extend PATH.
path=(~/bin $path)
path=(~/Library/Android/sdk/platform-tools $path)
path=(~/flutter/bin $path)
path=(~/flutter/.pub-cache/bin $path)
path=(~/.pub-cache/bin $path)

# Export environment variables.
export JAVA_HOME=$(/usr/libexec/java_home)

# Define aliases.
alias bundletool='java -jar /Users/daniel/bin/bundletool.jar'
alias flutter="fvm flutter"