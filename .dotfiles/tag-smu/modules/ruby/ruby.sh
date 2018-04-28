#!/bin/bash

readonly ruby_version="2.5.1"

echo "------------------------------"
echo "Running ruby module"
echo "------------------------------"
echo ""

brew bundle install --file="./brewfile"

echo "------------------------------"
rbenv init

if [[ -z "${SMU_ZSH_DIR+x}" ]]; then
    echo "It looks like you are not using the set-me-up terminal module."
    echo "Please follow the rbenv instructions above to complete the installation."
    read -n 1 -s -r -p "Press any key to continue."
    echo ""
fi

echo "------------------------------"
echo "Installing ruby ${ruby_version} and setting as global version"

rbenv install "${ruby_version}" -s
rbenv global "${ruby_version}"
