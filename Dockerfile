FROM ubuntu:trusty

# set environment variables
ENV PROJECT_ROOT /srv/app
ENV DOCUMENT_ROOT /var/www/html

# Install packages.
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
	wget \
	unzip \
	supervisor
RUN apt-get clean

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Setup SSH.
RUN mkdir /root/.ssh && chmod 700 /root/.ssh && touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
RUN echo 'root:root' | chpasswd
RUN sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd
RUN mkdir -p /root/.ssh
COPY keys/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Install Drush
RUN composer global require drush/drush
RUN ln -nsf /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Setup PHP.
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/cli/php.ini

# Setup Apache.
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Setup healthit
RUN ln -s /srv/app/site-php /var/www/site-php
RUN ln -s /srv/app/hitgov_drupal8 /var/www/html/hitgov_drupal8
# RUN chown -R www-data /var/www/html/hitgov_drupal8 && chmod -R g+w /var/www/html
RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/hitgov_drupal8\/docroot/' /etc/apache2/sites-available/000-default.conf

# Setup Supervisor.
RUN echo '[supervisord]\nnodaemon=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:apache2]\ncommand=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:sshd]\ncommand=/usr/sbin/sshd -D\n\n' >> /etc/supervisor/supervisord.conf

EXPOSE 80 2222
CMD ["/usr/bin/supervisord"]