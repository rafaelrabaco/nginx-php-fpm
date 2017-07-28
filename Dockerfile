FROM alpine:3.6

MAINTAINER rabaco <rafaelrabaco@gmail.com>

ENV NGINX_VERSION 1.12.0

# Install packages for running application
RUN apk --no-cache add php7-fpm php7-mcrypt php7-curl php7-gd  php7-intl php7-mbstring php7-opcache \
    php7-pdo_mysql php7-json php7-openssl php7-ctype php7-session php7-xml php7-dom php7-tokenizer \
    php7-fileinfo php7-zip php7-xmlwriter \
    git curl nginx supervisor \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    apk -U upgrade

# Install packages for nginx install
RUN apk --no-cache add ca-certificates libressl pcre zlib
RUN apk --no-cache add --virtual .build-deps build-base linux-headers libressl-dev pcre-dev wget zlib-dev

# Instal Nginx with http_realip_module
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar xzf nginx-${NGINX_VERSION}.tar.gz

RUN cd nginx-${NGINX_VERSION} \
  && ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-file-aio \
    --with-http_v2_module \
    --with-ipv6 \
    --with-stream_realip_module \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && sed -i -e 's/#access_log  logs\/access.log  main;/access_log \/dev\/stdout;/' -e 's/#error_log  logs\/error.log  notice;/error_log stderr notice;/' /etc/nginx/nginx.conf \
    && mkdir -p /var/cache/nginx \
    && apk del .build-deps \
    && rm -rf /tmp/*

RUN rm nginx-${NGINX_VERSION}.tar.gz
RUN rm -rf nginx-${NGINX_VERSION}

# Install composer
RUN apk --no-cache add php7 php7-common php7-cli php7-phar php7-json \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    apk -U upgrade
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure nginx
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx/sites-enabled/default.conf /etc/nginx/sites-enabled/default.conf
ADD conf/nginx/headers.conf /etc/nginx/headers.conf

# Configure PHP-FPM
COPY conf/php/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY conf/php/php.ini /etc/php7/conf.d/zzz_custom.ini

ADD conf/supervisord/supervisord.conf /etc/supervisord.conf

ADD VERSION .

EXPOSE 80 443
CMD ["supervisord"]