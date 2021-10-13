#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from user-data!"
yum update -y
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
yum install -y httpd jq
amazon-linux-extras install -y php7.3
yum install -y php-pecl-mcrypt php-pecl-imagick php-mbstring
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
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
yum install amazon-cloudwatch-agent -y
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux
amazon-cloudwatch-agent-ctl -a start
export instance_id_meta=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)
aws cloudwatch put-metric-alarm --alarm-name $instance_id_meta --alarm-description "disk over 80%" --metric-name disk_used_percent --namespace System/Linux --statistic Average --period 10 --threshold 80 --comparison-operator GreaterThanThreshold --dimensions Name=path,Value=/ "Name=InstanceId,Value=$instance_id_meta" Name=AutoScalingGroupName,Value=tf-asg-2021030909283798800000000b Name=ImageId,Value=ami-0e80a462ede03e653 Name=InstanceType,Value=t3.micro Name=device,Value=nvme0n1p1 Name=fstype,Value=xfs --evaluation-periods 2 --actions-enabled --ok-actions $notify --alarm-actions arn:aws:sns:eu-west-2:348638809043:CloudWatch_Alarms --unit Percent --region eu-west-2
