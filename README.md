#Prerequisites
Manually create wp_config_bucket S3 bucket in eu-west2 region and copy wp-config.php to root.
Bucket name in app-ha/install_wp.sh must be correct
Set Secrets in AWS Secrets Manager

secret name = db-creds
username = Master RDS username	
password = 	Master RDS password	
dbname = rds db name
host = 
WP Salts - DO NOT USE SPECIAL CHARACTERS - THE PHP PARSER CAN NOT HANDLE THEM
AUTH_KEY	
SECURE_AUTH_KEY	
LOGGED_IN_KEY	
NONCE_KEY	
AUTH_SALT	
SECURE_AUTH_SALT	
LOGGED_IN_SALT	
NONCE_SALT	

Create a parameter called AmazonCloudWatch-linux in SSM Parameter store and copy the contents of AmazonCloudWatch-linux to the value   

#Notes on Wordpress
This code will deploy Wordpress create and RDS MySQL database and configure wp-config.php. 
First time - Wordpress will then configuring by going to the Load Balancer dns name and entering details in the welcome page, after this the setup is written to the db and so persists.

#Notes on Secrets
Secrets have been managed using code from this site, secrets must be set in Secrets Manager manually.
https://www.rayheffer.com/aws-secrets-manager-for-wordpress-configuration/

#Deployment time
This solution takes around 20 mins to deploy the RDS database


#Manual steps
Must manually subscribe to sns topic

#Improvement
#Done
Done - Set RDS username via AWS Secrets Manager (SSM) rather than plain text.
# Working on
edit - install_wp_sh to include env variables etc

Currently wp-config.php is configured to use env variables but the user data is not

##Backlog
Tag everything
Make db hostname available as an output and automate deployment
Automate uploading of AmazonCloudWatch-linux to ssm
tighten security groups
Ensure variables are used where possible
Name private subnet 1&2, wordpress & rds
understand IAM - resource "aws_iam_policy" "lifecycle_policy" {
what does this do "amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2"







