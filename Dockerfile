FROM imoize/alpine-s6:3.19

ARG TARGETARCH
ARG PHP_VERSION

ENV PHP_VERSION=${PHP_VERSION}

# install packages
RUN \
apk update && apk add --no-cache \
    apache2-utils \
    ed \
    freetype-dev \
    ghostscript \
    gmp-dev \
    icu-libs \
    imagemagick \
    libavif \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    logrotate \
    mysql-client \
    openssl \
    zlib-dev && \
apk update && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    php${PHP_VERSION} \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-ftp \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-mysqlnd \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-posix \
    php${PHP_VERSION}-pecl-imagick \
    php${PHP_VERSION}-pecl-memcached \
    php${PHP_VERSION}-pecl-redis \
    php${PHP_VERSION}-pecl-ssh2 \
    php${PHP_VERSION}-pecl-zstd \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-sodium \
    php${PHP_VERSION}-sockets \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlreader \
    php${PHP_VERSION}-xmlwriter \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-zlib && \
# set correct php version is symlinked
  if [ "$(readlink /usr/bin/php)" != "php${PHP_VERSION}" ]; then \
    rm -rf /usr/bin/php && \
    ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php; \
  fi && \
# set php
  sed -i "s#user = nobody.*#user = disty#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#group = nobody.*#group = disty#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#group = nobody.*#group = disty#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#listen = 127.0.0.1:9000.*#listen = 0.0.0.0:9000#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#;request_terminate_timeout = 0.*#request_terminate_timeout = 600#g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
  sed -i "s#;error_log = log/php${PHP_VERSION}/error.log.*#error_log = /config/log/php/error.log#g" /etc/php${PHP_VERSION}/php-fpm.conf && \
# fix logrotate
  sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/periodic/daily/logrotate && \
# download latest wordpress
  curl -fLo /app/wordpress.tar.gz "https://wordpress.org/latest.tar.gz" && \
# cleanup
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

# add localfiles
COPY src/ /

# ports and workdir
WORKDIR /config
EXPOSE 9000