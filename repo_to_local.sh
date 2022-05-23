#!/bin/bash

CURRENTDATE=$(date +%s)

mkdir ~/dotfiles.backup.${CURRENTDATE}

mv ~/.p10k.zsh ~/dotfiles.backup.${CURRENTDATE}
mv ~/.zshenv ~/dotfiles.backup.${CURRENTDATE}
mv ~/.zshrc ~/dotfiles.backup.${CURRENTDATE}
mv ~/.personal.public.zsh ~/dotfiles.backup.${CURRENTDATE}
mv ~/.work.public.zsh ~/dotfiles.backup.${CURRENTDATE}


cp ./.p10k.zsh ~/.p10k.zsh
cp ./.zshenv ~/.zshenv
cp ./.zshrc ~/.zshrc

echo "Is this Personal or Work?"
select pw in "Personal" "Work"; do
    case $pw in
        Personal ) cp ./.personal.public.zsh ~/.personal.public.zsh; break;;
        Work ) cp ./.work.public.zsh ~/.work.public.zsh; break;;
    esac
done

exec zsh
