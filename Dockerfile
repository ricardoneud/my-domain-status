FROM php:8.2-apache
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
RUN apt-get update
RUN apt-get install libzip-dev -y
RUN docker-php-ext-install zip
RUN docker-php-ext-enable zip
RUN a2enmod rewrite
RUN touch /usr/local/etc/php/conf.d/ssp.ini
RUN echo "output_buffering = 16384" >> /usr/local/etc/php/conf.d/ssp.ini
RUN echo "display_errors = off" >> /usr/local/etc/php/conf.d/ssp.ini
RUN echo "error_reporting = E_ERROR" >> /usr/local/etc/php/conf.d/ssp.ini
RUN apt install git -y
WORKDIR /var/www/html
RUN docker-php-ext-install gettext
RUN docker-php-ext-install pdo_mysql
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) gd
RUN apt-get install -y locales
RUN locale-gen en_GB.UTF-8
RUN sed -i '/en_GB.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen