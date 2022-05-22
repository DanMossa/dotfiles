#!/bin/bash

CURRENTDATE=$(date +%s)

mkdir ~/dotfiles.backup.${CURRENTDATE}

mv ~/.p10k.zsh ~/dotfiles.backup.${CURRENTDATE}
mv ~/.personal.public.zsh ~/dotfiles.backup.${CURRENTDATE}
mv ~/.work.public.zsh ~/dotfiles.backup.${CURRENTDATE}
mv ~/.zshenv ~/dotfiles.backup.${CURRENTDATE}
mv ~/.zshrc ~/dotfiles.backup.${CURRENTDATE}

cp ./.p10k.zsh ~/.p10k.zsh
cp ./.personal.public.zsh ~/.personal.public.zsh
cp ./.work.public.zsh ~/.work.public.zsh
cp ./.zshenv ~/.zshenv
cp ./.zshrc ~/.zshrc

exec zsh