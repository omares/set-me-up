#!/bin/bash

readonly sublime_dir="${HOME}/Library/Application Support/Sublime Text 3"
readonly sublime_user_dir="${sublime_dir}/Packages/User"
readonly sublime_package_settings="${sublime_user_dir}/Package Control.sublime-settings"
readonly sublime_package_control="${sublime_dir}/Installed Packages/Package Control.sublime-package"
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

stdin_to_file() {
    local -r file="${1}"

    echo "$(</dev/stdin)" > "${file}"
}

sublime_merge_setting() {
    local -r settings="${1}"

    jq -e -s '.[0] + .[1]' "${sublime_user_dir}/${settings##*/}" "${settings}" | stdin_to_file "${sublime_user_dir}/${settings##*/}"
}

echo "------------------------------"
echo "Running editor module"
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"

if [[ ! $(command -v pip) == "" ]]; then
    pip install -U CodeIntel
    pip install -U neovim
fi

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

for settings in ./sublime/*.sublime-settings; do
    sublime_merge_setting "${settings}"
done

jq -e --argjson packages "$(printf '%s\0' "${sublime_packages[@]}" | jq -Rs 'split("\u0000")')" \
                         '.installed_packages |= (. + $packages | unique)' \
                         "${sublime_package_settings}"  | stdin_to_file "${sublime_package_settings}"

echo "------------------------------"
echo "Installing diff- and mergetools"

# https://pempek.net/articles/2014/04/18/git-p4merge/
curl -fsSL https://pempek.net/files/git-p4merge/mac/p4merge > /usr/local/bin/p4merge
chmod +x /usr/local/bin/p4merge

# https://github.com/so-fancy/diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
