#!/bin/bash

echo "------------------------------"
echo "Installing essential homebrew formulae and apps."
echo "This might awhile to complete, as some formulae need to be installed from source."
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"
