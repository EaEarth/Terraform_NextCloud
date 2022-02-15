#! /bin/bash
# get packages for nextcloud 
sudo apt-get update
sudo apt install -y apache2 libapache2-mod-php7.4
sudo apt install -y php7.4-gd php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl
sudo apt install -y php7.4-gmp php7.4-bcmath php-imagick php7.4-xml php7.4-zip
sudo apt install -y unzip
wget https://download.nextcloud.com/server/releases/nextcloud-22.2.2.zip -P /tmp
sudo unzip /tmp/nextcloud-22.2.2.zip  -d /var/www
sudo chown -R www-data: /var/www/nextcloud
sudo cat << EOF > /etc/apache2/conf-available/nextcloud.conf
Alias /nextcloud "/var/www/nextcloud/"

<Directory /var/www/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/nextcloud
 SetEnv HTTP_HOME /var/www/nextcloud

</Directory>
EOF

# config nextcloud database
cd /var/www/nextcloud/
sudo -i
cat << EOF > /var/www/nextcloud/config/autoconfig.php
<?php
\$AUTOCONFIG = array(
  "dbtype"        => "mysql",
  "dbname"        => "${database_name}",
  "dbuser"        => "${database_user}",
  "dbpass"        => "${database_pass}",
  "dbhost"        => "${database_host}",
  "dbtableprefix" => "",
  "adminlogin"    => "${admin_user}",
  "adminpass"     => "${admin_pass}",
  "directory"     => "/var/www/nextcloud/data",
);
EOF
cat << EOF > /var/www/nextcloud/config/storage.config.php
<?php
\$CONFIG = array (
  "objectstore" => array( 
      "class" => "OC\\Files\\ObjectStore\\\\S3",
      "arguments" => array(
        "bucket" => "${bucket_name}",
        "key"    => "${user_access_key}",
        "secret" => "${user_secret_key}",
        "use_ssl" => true,
        "region" => "${region}"
      ),
    ),
  );
EOF


a2ensite nextcloud.conf
sudo a2enconf nextcloud
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime
sudo systemctl restart apache2