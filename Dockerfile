FROM centos AS builder

WORKDIR /tmp
RUN yum install -y wget unzip

ARG VERSION=4.13.0
RUN wget https://cdn.domainmod.org/downloads/domainmod-v${VERSION}.zip
RUN unzip domainmod-v${VERSION}.zip

FROM php:7.4-apache
WORKDIR /
RUN docker-php-ext-install pdo_mysql
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/g' /usr/local/etc/php/php.ini
COPY --from=builder /tmp/domainmod /var/www/html
VOLUME ["/var/www/html"]
