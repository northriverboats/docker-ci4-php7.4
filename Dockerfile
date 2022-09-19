FROM php:7.4-apache

RUN apt-get clean -y \
    && apt-get update -y \
    && apt-get install -y \
       git \
       p7zip-full \
       libicu-dev \
    && apt-get clean -y

RUN pecl install redis-5.1.1 \
	&& pecl install xdebug-2.8.1 \
        && docker-php-ext-install intl \
	&& docker-php-ext-enable redis xdebug intl 
RUN a2enmod rewrite headers 

# for ci4 use /var/www and dockument root at /var/www/public 
# Change www-data user to match the host system UID and GID and chown www directory
ENV APACHE_DOCUMENT_ROOT /var/www/public
RUN usermod --non-unique --uid 1000 www-data \
  && groupmod --non-unique --gid 1000 www-data \
  && chown -R www-data:www-data /var/www \
  && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www
# make sure to start with -e APACHE_RUN_USER='#1000' -e APACHE_RUN_GROUP='#1000'
