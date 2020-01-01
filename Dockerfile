FROM php:7.1.0-apache
MAINTAINER Enric Mieza <enric@enricmieza.com>

RUN apt-get update \
	&& apt-get install -y wget \
	libpng-dev \
	&& apt-get install -y --no-install-recommends libtidy-dev libmagickwand-dev \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& docker-php-ext-install tidy \
	&& docker-php-ext-enable tidy \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-configure gd --with-jpeg-dir=/usr/include \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install gettext \
	&& a2enmod rewrite \
	&& apt-get clean && apt-get autoclean \
	&& rm -rf /var/lib/apt/lists/* \
	&& groupadd -g 10000 media \
	&& usermod -a -G media www-data

COPY php.ini /usr/local/etc/php/conf.d/php.ini

COPY vhost /etc/apache2/sites-available/000-default.conf

RUN rm -rf /var/www/html/* \
	&& wget -O /zenphoto.tar.gz https://github.com/zenphoto/zenphoto/archive/v1.5.6.tar.gz \
	&& tar xfz /zenphoto.tar.gz -C /var/www/html --strip-components=1 \
	&& rm /zenphoto.tar.gz \
	&& mkdir /var/www/html/cache \
	&& mkdir /var/www/html/cache_html \
	&& chown www-data /var/www/html/albums \
	&& chown www-data /var/www/html/uploaded \
	&& chown www-data /var/www/html/zp-data \
	&& chown www-data /var/www/html/plugins \
	&& chown www-data /var/www/html/cache \
	&& chown www-data /var/www/html/cache_html

COPY security /var/www/html/.htaccess

COPY run.sh /run.sh

CMD ["/run.sh"]
