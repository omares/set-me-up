#!/bin/bash

readonly phpswitch_executable="/usr/local/bin/phpswitch"

get_php_ini() {
    echo `php -i 2> /dev/null | grep 'Loaded Configuration File' | sed 's/Loaded Configuration File => //'`
}

switch_version() {
    local -r php_version="${1}"

    phpswitch "${php_version}" -s=valet,apache

    local -r extension_dir=`php-config --extension-dir`

    # try our best to have a correct pear/pecl setup
    pear config-set php_ini "$(get_php_ini)"
    pear config-set ext_dir "${extension_dir}"
}

extension_install() {
    local -r extension="${1}"

    printf "\n" | pecl install "${extension}"
}

extension_uninstall() {
    local -r extension="${1}"

    # try to remove extension so we have a clean base
    pecl uninstall "${extension}"

    local -r search='/extension="'"${extension%-*}"'/d'

    # pecl fails to remove the extension from the ini
    sed -i '' "${search}" "$(get_php_ini)"
}

memcached_install() {
    local -r memcached_source="${1}"

    readonly ini_dir=`php -i | grep 'Scan this dir for additional .ini files' | sed 's/Scan this dir for additional .ini files => //'`
    readonly build_dir=`mktemp --tmpdir -d 'tmp.memcached.XXXXXXX'`

    cd "${build_dir}"
    curl -#L "${memcached_source}" | tar -xv --strip-components 1 --exclude={README.md,LICENSE}

    phpize
    ./configure --enable-memcached-igbinary --enable-memcached-json
    make
    make install

    echo "extension=\"memcached.so\"" > "${ini_dir}/memcached.ini"
}

echo "------------------------------"
echo "Running PHP module"
echo "------------------------------"
echo ""

# xcode zlib is required for the memcached extension
if [[ -z $(xcode-select -p) ]]; then
    echo "------------------------------"
    echo "Installing Xcode Command Line Tools."

    xcode-select --install
fi

brew bundle install --file="./brewfile"

echo "------------------------------"
echo "Installing php version switcher..."

curl -fsSL https://raw.githubusercontent.com/philcook/brew-php-switcher/master/phpswitch.sh > "${phpswitch_executable}"
chmod +x "${phpswitch_executable}"

echo "------------------------------"
echo "Installing PHP 5.6 extensions..."
( source "./php56_extensions.sh" )

echo "------------------------------"
echo "Installing PHP 7.2 extensions..."
( source "./php72_extensions.sh" )
