#!/bin/bash

echo "------------------------------"
echo "Updating macOS. If this requires a restart, run the script again."
echo "------------------------------"
echo ""

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install all available updates
sudo softwareupdate -i -a

if [[ -z $(xcode-select -p) ]]; then
    echo "------------------------------"
    echo "Installing Xcode Command Line Tools."

    xcode-select --install
fi
