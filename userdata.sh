#!/bin/bash
sudo yum update -y
sudo yum install httpd php php-mysqlnd -y
cd /var/www/html
echo "This is a test file" > indextest.html
sudo yum install wget -y
wget https://wordpress.org/wordpress-6.1.1.tar.gz
tar -xzf wordpress-6.1.1.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf wordpress-6.1.1.tar.gz
chmod -R 755 wp-content
chown -R apache:apache wp-content
cd /var/www/html && mv wp-config-sample.php wp-config.php
sed -i "s@define( 'DB_NAME', 'database_name_here' )@define( 'DB_NAME', 'wordpressdb' )@g" /var/www/html/wp-config.php
sed -i "s@define( 'DB_USER', 'username_here' )@define( 'DB_USER', 'admin' )@g" /var/www/html/wp-config.php
sed -i "s@define( 'DB_PASSWORD', 'password_here' )@define( 'DB_PASSWORD', 'admin123' )@g" /var/www/html/wp-config.php
sed -i "s@define( 'DB_HOST', 'localhost' )@define( 'DB_HOST', 'database-1.cxnm2hbnjelv.eu-west-1.rds.amazonaws.com' )@g" /var/www/html/wp-config.php
sudo chkconfig httpd on
sudo service httpd start
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config


# Detailed breakdown of the Userdata (this is based on RedHat OS) 
# sudo yum install httpd php php-mysqlnd -y: This installs the Apache web server (httpd), PHP, and the PHP MySQL extension on the system using the yum package manager.

# cd /var/www/html: Changes the working directory to the web server's root directory.

# echo "This is a test file" > indextest.html: Creates a simple test HTML file named indextest.html with the content "This is a test file".

# sudo yum install wget -y: Installs the wget command-line utility, which is used for downloading files from the internet.

# wget https://wordpress.org/wordpress-6.1.1.tar.gz: Downloads the WordPress package (version 6.1.1) from the official WordPress website.

# tar -xzf wordpress-6.1.1.tar.gz: Extracts the contents of the downloaded WordPress archive.

# cp -r wordpress/* /var/www/html/: Copies the contents of the extracted WordPress directory to the web server's root directory.

# rm -rf wordpress: Removes the now unnecessary WordPress directory.

# rm -rf wordpress-6.1.1.tar.gz: Removes the downloaded WordPress archive.

# chmod -R 755 wp-content: Changes the permissions of the wp-content directory to allow read, write, and execute access for the owner, and read and execute access for others.

# chown -R apache:apache wp-content: Changes the ownership of the wp-content directory and its contents to the apache user and group.

# cd /var/www/html && mv wp-config-sample.php wp-config.php: Moves the sample configuration file for WordPress (wp-config-sample.php) to wp-config.php.

# The next four sed commands are used to edit the wp-config.php file and update the database connection details:

# sed -i "s@define( 'DB_NAME', 'database_name_here' )@define( 'DB_NAME', 'wordpressdb' )@g": Replaces the placeholder database name with YOUR_DATABASE_NAME.

# sed -i "s@define( 'DB_USER', 'username_here' )@define( 'DB_USER', 'admin' )@g": Replaces the placeholder database username with admin.

# sed -i "s@define( 'DB_PASSWORD', 'password_here' )@define( 'DB_PASSWORD', 'admin123' )@g": Replaces the placeholder database password with admin123.

# sed -i "s@define( 'DB_HOST', 'localhost' )@define( 'DB_HOST', 'database-1.cxnm2hbnjelv.eu-west-1.rds.amazonaws.com' )@g": Updates the database host to YOUR_DATABASE_ENDPOINT.

# sudo chkconfig httpd on: Configures Apache to start automatically on boot.

# sudo service httpd start: Starts the Apache web server.

# sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config: This sed command modifies the SELinux configuration to disable it. SELinux is a security feature in Linux.

# sudo reboot: Reboots the system to apply the changes.