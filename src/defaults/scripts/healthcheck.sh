#!/command/with-contenv bash
# shellcheck shell=bash

# Load Generic Libraries
. /defaults/scripts/liblog.sh

# Check if Nginx and PHP-FPM services are healthy.

# Check PHP-FPM
if ps aux | grep -v grep | grep "php-fpm${PHP_VERSION}" > /dev/null; then
    echo "$info ==> PHP-FPM is running."
else
    echo "$warn ==> Health check failed: PHP-FPM is not running."
    exit 1
fi

echo "$info ==> Healthcheck is successful."
exit 0