#!/command/with-contenv bash
# shellcheck shell=bash

replace_in_file() {
    local filename="${1:?filename is required}"
    local match_regex="${2:?match regex is required}"
    local substitute_regex="${3:?substitute regex is required}"
    local posix_regex=${4:-true}

    local result

    # We should avoid using 'sed in-place' substitutions
    # 1) They are not compatible with files mounted from ConfigMap(s)
    # 2) We found incompatibility issues with Debian10 and "in-place" substitutions
    local -r del=$'\001' # Use a non-printable character as a 'sed' delimiter to avoid issues
    if [[ $posix_regex = true ]]; then
        result="$(sed -E "s${del}${match_regex}${del}${substitute_regex}${del}g" "$filename")"
    else
        result="$(sed "s${del}${match_regex}${del}${substitute_regex}${del}g" "$filename")"
    fi
    echo "$result" > "$filename"
}

wordpress_conf_set() {
    local -r key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    value="${value//[$'\t\n\r']}"
    [[ "$value" = "" ]] && value="\"$value\""

    replace_in_file "${WORDPRESS_DIR}/wp-config.php" "define( '$key', '.*' );" "define( '$key', '$value' );" false
}