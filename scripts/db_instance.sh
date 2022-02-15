#! /bin/bash
sudo apt-get update
sudo apt install -y mariadb-server
sudo /etc/init.d/mysql start
sudo mysql -Bse "
CREATE USER '${database_user}'@'%' IDENTIFIED BY '${database_pass}';
CREATE DATABASE ${database_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO '${database_user}'@'%';
FLUSH PRIVILEGES;"

# configure remote 
sudo -i
cat <<- EOF > /etc/mysql/my.cnf
[mysqld]
skip-networking=0
skip-bind-address
EOF
sudo systemctl restart mariadb