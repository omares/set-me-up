#!/bin/bash

readonly sublime_directory="${HOME}/Library/Application Support/Sublime Text 3"
readonly sublime_settings="${sublime_directory}/Packages/User/Preferences.sublime-settings"
readonly sublime_package_control="${sublime_directory}/Installed Packages/Package Control.sublime-package"
readonly sublime_package_settings="${sublime_directory}/Packages/User/Package Control.sublime-settings"
readonly sublime_packages=(
    "A File Icon"
    "Alignment"
    "AutoFileName"
    "BracketHighlighter"
    "Emmet"
    "GhostText"
    "GitHubinator"
    "GitGutter"
    "SideBarEnhancements"
    "SublimeLinter"
    "SublimeCodeIntel"
    "TrailingSpaces"
)

echo "------------------------------"
echo "Running editor module"
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"

echo "------------------------------"
echo "Installing spacevim"

curl -sLf https://spacevim.org/install.sh | bash

if [[ ! -e "${sublime_package_control}" ]]; then
    echo "------------------------------"
    echo "Installing Sublime3 package control"

    curl -fsSL "https://packagecontrol.io/Package%20Control.sublime-package" > "${sublime_package_control}"
fi

echo "------------------------------"
echo "Merging Sublime3 settings"

tmp_settings=$(mktemp);

jq -e -s '.[0] + .[1]' "${sublime_settings}" "./sublime/Preferences.sublime-settings" > "${tmp_settings}"

if [[ $? -eq 0 ]]; then
    mv "${tmp_settings}" "${sublime_settings}"
fi

rm -f "${tmp_settings}"

echo "------------------------------"
echo "Adding Sublime3 packages"

if [[ ! -e "${sublime_package_settings}" ]]; then
    cp "./sublime/Package Control.sublime-settings" "${sublime_package_settings}"
fi

if [[ ! $(command -v pip) == "" ]]; then
    pip install -U CodeIntel
fi

tmp_packages=$(mktemp);

jq -e --argjson packages "$(printf '%s\0' "${sublime_packages[@]}" | jq -Rs 'split("\u0000")')" \
'.installed_packages |= (. + $packages | unique)' \
"${sublime_package_settings}" > "${tmp_packages}"

if [[ $? -eq 0 ]]; then
    mv "${tmp_packages}" "${sublime_package_settings}"
fi

rm -f "${tmp_packages}"

echo "------------------------------"
echo "Installing diff- and mergetools"

# https://pempek.net/articles/2014/04/18/git-p4merge/
curl -fsSL https://pempek.net/files/git-p4merge/mac/p4merge > /usr/local/bin/p4merge
chmod +x /usr/local/bin/p4merge

# https://github.com/so-fancy/diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
