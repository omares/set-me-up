#!/bin/bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run the core.sh Script
# For a full listing of installed formulae and apps, refer to
# the commented core.sh source file directly and tweak it to
# suit your needs.

echo "------------------------------"
echo "Installing essential homebrew formulae and apps."
echo "This might awhile to complete, as some formulae need to be installed from source."
echo "------------------------------"
echo ""

brew bundle install --file="${SCRIPT_DIR}/../brewfiles/essentials"

# Lxml and Libxslt
brew link libxml2 --force
brew link libxslt --force
