#!/bin/bash

readonly extensions=("apcu-4.0.11" "amqp-1.9.3" "igbinary-2.0.5" "xdebug-2.5.5")

switch_version "5.6"

for extension in "${extensions[@]}"
do
    extension_uninstall "${extension}"
    extension_install "${extension}"
done

memcached_install "https://github.com/php-memcached-dev/php-memcached/archive/2.2.0.tar.gz"
