#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from user-data!"
yum update -y
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
yum install -y httpd mariadb-server jq
amazon-linux-extras install -y php7.3
yum install -y php-pecl-mcrypt php-pecl-imagick php-mbstring
systemctl enable mariadb
systemctl start mariadb
systemctl enable httpd
systemctl start httpd
rsync -r /tmp/wordpress/. /var/www/html
aws s3 cp s3://wp-config-bucket/wp-config.php /var/www/wp-config.php
aws secretsmanager get-secret-value --secret-id db-creds --query SecretString --version-stage AWSCURRENT --region eu-west-2 --output text | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' > /var/www/.env
curl -sS https://getcomposer.org/installer | sudo php
mv composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer
cd /var/www/
wget https://raw.githubusercontent.com/rayheffer/wp-secrets/master/composer.json
sudo composer install
chown -R apache:apache /var/www/