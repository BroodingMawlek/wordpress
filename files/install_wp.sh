#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
yum -y update
echo "Hello from user-data!"
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
yum install amazon-cloudwatch-agent -y
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux
amazon-cloudwatch-agent-ctl -a start
yum install -y httpd
service httpd start
wget -O /usr/bin/latest.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf /usr/bin/latest.tar.gz --directory /usr/bin/
cp -r /usr/bin/wordpress/* /var/www/html/
aws s3 cp s3://wp-config-bucket/wp-config.php /var/www/html/wp-config.php
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
service httpd stop
service httpd start
export instance_id_meta=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)
aws cloudwatch put-metric-alarm --alarm-name $instance_id_meta --alarm-description "disk over 80%" --metric-name disk_used_percent --namespace System/Linux --statistic Average --period 10 --threshold 80 --comparison-operator GreaterThanThreshold --dimensions Name=path,Value=/ "Name=InstanceId,Value=$instance_id_meta" Name=AutoScalingGroupName,Value=tf-asg-2021030909283798800000000b Name=ImageId,Value=ami-0e80a462ede03e653 Name=InstanceType,Value=t3.micro Name=device,Value=nvme0n1p1 Name=fstype,Value=xfs --evaluation-periods 2 --actions-enabled --ok-actions $notify --alarm-actions arn:aws:sns:eu-west-2:348638809043:CloudWatch_Alarms --unit Percent --region eu-west-2
echo "Composer install"
cd /tmp
curl -sS https://getcomposer.org/installer | sudo php
mv composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer
echo "PHP DotEnv install"
cd /var/www/
wget https://raw.githubusercontent.com/rayheffer/wp-secrets/master/composer.json
composer install
chown -R apache:apache /var/www/
echo "Install jq"
yum install -y jq
echo "Download Secrets to /var/www/.env"
aws secretsmanager get-secret-value --secret-id db-creds --query SecretString --version-stage AWSCURRENT --region eu-west-2 --output text | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' > /var/www/.env