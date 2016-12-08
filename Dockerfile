FROM ubuntu:trusty

# Set environment variables
# Application inside vagrant VM healthithost
ENV PROJECT_ROOT /srv/app
# Apache serving directory inside Docker container
ENV DOCUMENT_ROOT /var/www

# Install packages
RUN apt-get update
RUN apt-get install -y \
		vim \
		git \
		apache2 \
		php-apc \
		php5-fpm \
		php5-cli \
		php5-mysql \
		php5-gd \
		php5-curl \
		libapache2-mod-php5 \
		curl \
		mysql-client \
		openssh-server \
		phpmyadmin \
		wget \
		unzip
RUN apt-get clean

# Install composer
RUN curl -Ss https://getcomposer.org/installer | php
RUN  mv composer.phar /usr/local/bin/composer

# Setup SSH

# Install Drush
RUN composer global require drush/drush

# Setup PHP

# Setup Apache
