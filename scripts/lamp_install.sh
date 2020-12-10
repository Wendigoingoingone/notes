#!/bin/bash
# This is call a shebang; it is the executable that
# will be used to run the script.

# Install the IUS repo (WordPress needs a higher version of PHP to run).
# Source: https://ius.io/setup
yum install -y https://repo.ius.io/ius-release-el7.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# We added -y so that the script is not interactive.

# Package Installs (Apache, MySQL, PHP)
yum install -y httpd mod_ssl mariadb-server php74-json mod_php74 php74-mysqlnd

# Service Management
systemctl enable httpd.service mariadb.service
systemctl restart httpd.service mariadb.service

# MySQL Configuration
mysql -e "create database scout;"
mysql -e "create user 'heavy'@'localhost' identified by 'testpass';"
mysql -e "grant all privileges on scout.* to 'heavy'@'localhost';"

# Wordpress:

wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/* /var/www/html/

# Cleanup
chown -R apache: /var/www/html/
rmdir wordpress
rm -f latest.tar.gz

### TODO
# * Output explaning what the script does (-h flag)
# * Suppress verbose output; remove clutter.
# * Add the ability to specify WordPress name when running script.
#    - Sanity check to ensure that MySQL is not trying to create a database name with a -.
# * Add the ability to create multiple installs.
#    - How do you run multiple sites from Apache?
# * Add the ability to auto-generate secure passwords. Create a file with the passwords for use later.


