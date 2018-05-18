#!/bin/bash

# github user/repo value of your set-me-up blueprint. E.g.: omares/set-me-up-blueprint
# set this value when  the installer should additionally obtain your blueprint
readonly SMU_BLUEPRINT=${SMU_BLUEPRINT:-""}

# the set-me-up version to download
readonly SMU_VERSION=${SMU_VERSION:-"master"}

# where to install set-me-up
SMU_HOME_DIR=${SMU_HOME_DIR:-"${HOME}/set-me-up"}

readonly smu_download="https://github.com/omares/set-me-up/tarball/${SMU_VERSION}"
readonly smu_blueprint_download="https://github.com/${SMU_BLUEPRINT}/tarball/master"

function mkcd() {
    local -r dir="${1}"

    if [[ ! -d "${dir}" ]]; then
        mkdir "${dir}"
    fi

    cd "${dir}"
}

function is_git_repo() {
    [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) ]] && true || false
}

function confirm() {
    echo "➜ Will download set-me-up to ${SMU_HOME_DIR}"
    read -p "Are you ok with that? (y/n) " -n 1;
    echo "";

    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
}

function obtain() {
    local -r download_url="${1}"

    curl --progress-bar -L ${download_url} | tar -x --strip-components 1 --exclude={README.md,LICENSE,screenshots,.gitignore}
}

function use_curl() {
    confirm
    mkcd "${SMU_HOME_DIR}"

    echo "➜ Obtaining set-me-up."
    obtain "${smu_download}"

    if [[ "${SMU_BLUEPRINT}" != "" ]]; then
        echo "➜ Obtaining your set-me-up blueprint."
        obtain "${smu_blueprint_download}"
    fi

    echo -e "\n➜ Done. Enjoy."
}

function use_git() {
    confirm
    mkcd "${SMU_HOME_DIR}"

    echo "➜ Obtaining set-me-up."
    obtain "${smu_download}"

    if [[ "${SMU_BLUEPRINT}" != "" ]]; then
        if is_git_repo; then
            echo "➜ Updating your set-me-up blueprint."
            git pull --ff -r
        else
            echo "➜ Cloning your set-me-up blueprint."
            git init
            git remote add origin "git@github.com:${SMU_BLUEPRINT}.git"
            git fetch
            git checkout -t origin/master
        fi
    fi


    echo -e "\n➜ Done. Enjoy."
}

function main() {
    method="curl"

    while [[ $# -gt 0 ]]; do
        arguments="$1"
        case "$arguments" in
            --git)
                method="git"
                ;;
            --detect)
                if is_git_repo; then method="git"; fi
                ;;
            --latest)
                SMU_VERSION="master"
                ;;

        esac

        shift
    done

    case "${method}" in
        curl)
            ( use_curl )
            exit
            ;;
        git)
            ( use_git )
            exit
            ;;
    esac
}

main $@
