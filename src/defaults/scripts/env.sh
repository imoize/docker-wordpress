#!/command/with-contenv bash
# shellcheck shell=bash

# Environment configuration

# The values for all environment variables will be set in the below order of precedence
# 1. Environment variables overridden via external files using *__FILE variables (see below)

# By setting an environment variable matching *__FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
wordpress_env_vars=(
    WORDPRESS_DB_HOST
    WORDPRESS_DB_NAME
    WORDPRESS_DB_USER
    WORDPRESS_DB_PASSWORD
    WORDPRESS_TABLE_PREFIX
)

for env_var in "${wordpress_env_vars[@]}"; do
    file_env_var="${env_var}__FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        if [[ -r "${!file_env_var:-}" ]]; then
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            echo "==> Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done

unset wordpress_env_vars

# PHP configuration
export MEMORY_LIMIT="${MEMORY_LIMIT:-"256M"}"
export MAX_INPUT_TIME="${MAX_INPUT_TIME:-"600"}"
export MAX_INPUT_VARS="${MAX_INPUT_VARS:-"5000"}"
export MAX_FILE_UPLOADS="${MAX_FILE_UPLOADS:-"20"}"
export MAX_EXECUTION_TIME="${MAX_EXECUTION_TIME:-"600"}"
export POST_MAX_SIZE="${POST_MAX_SIZE:-"16M"}"
export UPLOAD_MAX_FILESIZE="${UPLOAD_MAX_FILESIZE:-"16M"}"
export OPCACHE_ENABLE="${OPCACHE_ENABLE:-"true"}"

# Wordpress Directory
export WORDPRESS_DIR="/config/www"

# Wordpress Database configuration
export BYPASS_DB_CHECK="${BYPASS_DB_CHECK:-no}"
export WORDPRESS_DB_HOST="${WORDPRESS_DB_HOST:-}"
export WORDPRESS_DB_NAME="${WORDPRESS_DB_NAME:-}"
export WORDPRESS_DB_USER="${WORDPRESS_DB_USER:-}"
export WORDPRESS_DB_PASSWORD="${WORDPRESS_DB_PASSWORD:-}"
export WORDPRESS_TABLE_PREFIX="${WORDPRESS_TABLE_PREFIX:-"wpx_"}"