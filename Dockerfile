FROM ubuntu:xenial
MAINTAINER Enric Mieza <enric@enricmieza.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
apt-get install -y wget \
	apache2 \
	libapache2-mod-php \
	php-mysql \
	php-gd \
	php-mbstring && \
	apt-get clean && apt-get autoclean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/www/html/* && \
	wget -O /zenphoto.tar.gz https://github.com/zenphoto/zenphoto/archive/zenphoto-1.4.12.tar.gz && \
	sed -i "/upload_max_filesize/c\upload_max_filesize = 20M" /etc/php/7.0/apache2/php.ini && \
	echo "<Directory /var/www>" >> /etc/apache2/sites-available/000-default.conf && \
	echo "	AllowOverride All" >> /etc/apache2/sites-available/000-default.conf && \
	echo "	Options -Indexes +FollowSymLinks" >> /etc/apache2/sites-available/000-default.conf && \
	echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf && \
	sed -i "/<\/VirtualHost>/d" /etc/apache2/sites-available/000-default.conf && \
	echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

ADD run.sh /run.sh

EXPOSE 80

CMD ["/bin/bash","/run.sh"]
