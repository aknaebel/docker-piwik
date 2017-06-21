FROM alpine:edge

MAINTAINER Alain Knaebel <alain.knaebel@aknaebel.fr>

RUN echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS="gnupg build-base autoconf automake libtool geoip-dev" \

 && apk upgrade --update\
 && apk add ca-certificates openssl \
      php7-fpm php7 php7-ctype php7-dom php7-gd php7-iconv php7-json php7-xml php7-mbstring php7-posix php7-zip php7-zlib php7-session \
      php7-pdo_mysql php7-curl php7-gd php7-mbstring php7-zip php7-xml php7-openssl php7-simplexml \
      php7-pear php7-dev \
      bzip2 \
      mysql-client \
      curl \
      zip unzip tar \
      bash geoip \
      ${BUILD_DEPS} \
 && curl -fsSL -o /tmp/geoip.tgz https://pecl.php.net/get/geoip \
 && cd /tmp && tar xzf /tmp/geoip.tgz && cd geoip-* \
 && phpize7 && ./configure --with-php-config=/usr/bin/php-config7 \
 && make && make install \
 && echo "extension=geoip.so" > /etc/php7/conf.d/00_geoip.ini \

 && apk del ${BUILD_DEPS} php7-pear php7-dev \
 && rm -rf /var/cache/apk/* /tmp/* \

 && addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -G www-data www-data \
 && mkdir -p /var/www/piwik \

 && echo "date.timezone = 'UTC'" > /etc/php7/php.ini \
 && echo "short_open_tag = 0" >> /etc/php7/php.ini \
 && echo "always_populate_raw_post_data=-1" >> /etc/php7/php.ini \
 && echo "geoip.custom_directory=/var/www/piwik/misc" >> /etc/php7/php.ini \

 && curl -fsSL -o /tmp/piwik.zip https://builds.piwik.org/piwik.zip \
 && cd /tmp/ && unzip piwik.zip && rm piwik.zip

WORKDIR /var/www/piwik
VOLUME /var/www/piwik

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./php-fpm.conf /etc/php7/php-fpm.conf

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm7", "-F"]
