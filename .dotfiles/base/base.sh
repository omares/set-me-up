#!/bin/bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating homebrew..."
    brew update
fi


if [[ $(command -v rcup) == "" ]]; then

    echo "------------------------------"
    echo "Installing rcm suite"

    brew bundle install -v --file="./brewfile"
fi


echo "------------------------------"
echo "Updating and/or installing dotfiles"
echo "------------------------------"

# Update and/or install dotfiles. These dotfiles are stored in the .dotfiles directory.
# rcup is used to install files from the tag-specific dotfiles directory.
# rcup is part of rcm, a management suite for dotfiles
# Check https://github.com/thoughtbot/rcm for more info

# get the absolute path of the .dotfiles directory
# this is only for aesthetic reasons to have an absolute symlink path instead of a relative one
# <path-to-smu>/.dotfiles/somedotfile vs <path-to-smu>/.dotfiles/base/../somedotfile
readonly dotfiles="$(dirname -- "$(dirname -- "$(greadlink -f -- "$0")")")"

export RCRC="../rcrc"
rcup -v -d "${dotfiles}"
