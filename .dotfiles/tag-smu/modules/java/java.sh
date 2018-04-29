#!/bin/bash

readonly java8="8.0.171-oracle"
readonly java10="10.0.1-oracle"
readonly kotlin1="1.2.41"
readonly maven3="3.5.3"
readonly gradle4="4.7"

sdk_install() {
    local -r candidate="${1}"
    local -r version="${2}"

    echo "------------------------------"
    echo "Installing ${candidate} ${version}"

    printf "\n" | sdk install "${candidate}" "${version}"
}

echo "------------------------------"
echo "Running java module"
echo "------------------------------"
echo ""

if [[ ! -z "${SDKMAN_DIR+x}" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    echo "------------------------------"
    echo "Updating sdkman"
    sdk selfupdate force
else
    echo "------------------------------"
    echo "Installing sdkman"
    curl -s "https://get.sdkman.io" | bash

    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

sdkman_auto_answer=true

sdk_install "java" "${java8}"
sdk_install "java" "${java10}"

sdk_install "kotlin" "${kotlin1}"

sdk_install "maven" "${maven3}"
sdk_install "gradle" "${gradle4}"

echo "------------------------------"
echo "Setting java ${java8} as global version"
sdk default "java" "${java8}"

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"

