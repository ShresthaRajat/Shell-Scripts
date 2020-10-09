#!/bin/bash
mysql_root_pw="root"
mysql_db_name="wp_db"
mysql_user_name="wp_user"
mysql_user_password="wp_user"

# Setting up lamp server

apt update && upgrade -y
apt install apache2 mysql-server php libapache2-mod-php php-mysql expect -y
ufw allow in "Apache"
ufw allow ssh
ufw --force enable
ufw status >> /var/www/html/installation.log # must display apache and apache v6
php -v >> /var/www/html/installation.log
echo '<?php phpinfo(); ?>' >> /var/www/html/phpinfo.php
echo -e "\n\n** LAMP Installation finished **" >> /var/www/html/installation.log

# Setting up Mysql Database

echo -e "\n\n** Starting mysql configuration **\n\n" >> /var/www/html/installation.log

[ ! -e /usr/bin/expect ] && { apt-get -y install expect; }
SECURE_MYSQL=$(expect -c "

set timeout 10
spawn mysql_secure_installation

expect \"Press y|Y for Yes, any other key for No: \"
send \"n\r\"
expect \"New password: \"
send \"root\r\"
expect \"Re-enter new password: \"
send \"root\r\"
expect \"Remove anonymous users? (Press y|Y for Yes, any other key for No) : \"
send \"y\r\"
expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) : \"
send \"y\r\"
expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) : \"
send \"y\r\"
expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) : \"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL" >> /var/www/html/installation.log

mysql -uroot -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"
echo -e "changed mysql db root password to 'root'" >> /var/www/html/installation.log
mysql -uroot -proot -e "create database $mysql_db_name";
mysql -uroot -proot -e "create user '$mysql_user_name'@'localhost' identified by password '$mysql_user_password'";
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON $mysql_db_name.* TO $mysql_user_name@localhost";
mysql -uroot -proot -e "FLUSH PRIVILEGES";

echo -e "\n\nroot pw: root" >> /var/www/html/installation.log
echo -e "db name: $mysql_db_name" >> /var/www/html/installation.log
echo -e "username: $mysql_user_name" >> /var/www/html/installation.log
echo -e "userpassword: $mysql_user_password" >> /var/www/html/installation.log

echo -e "\n\n** Finished Setting up mysql **" >> /var/www/html/installation.log
