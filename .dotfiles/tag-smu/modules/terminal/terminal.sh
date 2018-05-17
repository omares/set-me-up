#!/bin/bash

readonly zsh_executable=${zsh_executable:-"/usr/local/bin/zsh"}

echo "------------------------------"
echo "Setting up zsh."
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"

echo "------------------------------"
echo "Installing zplugin..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"

if ! grep -q "${zsh_executable}" "/etc/shells"; then
    echo "${zsh_executable}" | sudo tee -a /etc/shells
fi

if [[ $SHELL != "${zsh_executable}" ]]; then
    echo "------------------------------"
    echo "Setting zsh as default shell..."
    chsh -s "${zsh_executable}"
fi

if [[ ! -d ${ZDOTDIR:-$HOME}/.zsh/cache ]]; then
    mkdir ${ZDOTDIR:-$HOME}/.zsh/cache
fi

if [[ ! -d ${ZDOTDIR:-$HOME}/.zsh/cache/.zcompcache ]]; then
    mkdir ${ZDOTDIR:-$HOME}/.zsh/cache/.zcompcache
fi

echo "------------------------------"
echo "Installing zsh plugins..."

zsh -c 'source ~/.zshrc; zplugin self-update'
