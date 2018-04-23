#!/bin/bash

readonly extensions=("apcu-5.1.11" "amqp-1.9.3" "igbinary-2.0.5" "xdebug-2.6.0")

switch_version "7.2"

for extension in "${extensions[@]}"
do
    extension_uninstall "${extension}"
    extension_install "${extension}"
done

memcached_install "https://github.com/php-memcached-dev/php-memcached/archive/v3.0.4.tar.gz"
