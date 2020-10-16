#!/bin/sh
echo "Wordpress installer started" >> /tmp/i.log
apt update
apt install wordpress php libapache2-mod-php mysql-server php-mysql -y
tee -a /etc/apache2/sites-available/wordpress.conf << END
Alias /blog /usr/share/wordpress
<Directory /usr/share/wordpress>
   Options FollowSymLinks
   AllowOverride Limit Options FileInfo
   DirectoryIndex index.php
   Order allow,deny
   Allow from all
</Directory>
<Directory /usr/share/wordpress/wp-content>
   Options FollowSymLinks
   Order allow,deny
   Allow from all
</Directory>
END
a2ensite wordpress && a2enmod rewrite && service apache2 reload
echo "Apache configured for wordpress and restarted" >> /tmp/i.log
mysql -uroot -proot -e "create database wordpress";
mysql -uroot -proot -e "CREATE USER wordpress@localhost IDENTIFIED BY 'password'";
mysql -uroot -proot -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost";
mysql -uroot -proot -e "FLUSH PRIVILEGES";
tee -a /etc/wordpress/config-$(wget -qO - icanhazip.com).php << END
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'password');
define('DB_HOST', 'localhost');
define('DB_COLLATE', 'utf8_general_ci');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
?>
END
service mysql start
echo "Database configured: wordpress/password" >> /tmp/i.log
echo "Installation Finished visit: $(wget -qO - icanhazip.com)/blog" >> /tmp/i.log

