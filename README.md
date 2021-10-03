#Prerequisites
Manually create wp_config_bucket S3 bucket in eu-west2 region and copy wp-config.php to root.
Bucket name in app-ha/install_wp.sh must be correct

Create a parameter called AmazonCloudWatch-linux in SSM Parameter store and copy the contents of AmazonCloudWatch-linux to the value   

#Notes on Wordpress
This code will deploy Wordpress create and RDS MySQL database and configure wp-config.php. Wordpress will then need configuring by going to the Load Balancer dns name and entering details in the welcome page.

#Notes on Code
Outputs are specified in the module and in the code e.g.
app-ha/outputs.tf

output wp_private_subnets {
  description = "IDs of the Application VPC's private subnets"
  value       = module.vpc.private_subnets
}
#Deployment time
This solution takes around 20 mins to deploy the RDS database


#Manual steps
Must manually subscribe to sns topic

#Improvement
#Done
Done - Set RDS username via AWS Secrets Manager (SSM) rather than plain text.
# Working on
edit - install_wp_sh to include env variables etc

##Backlog
Tag everything
Make db hostname available as an output and automate deployment
Automate uploading of AmazonCloudWatch-linux to ssm
tighten security groups
Ensure variables are used where possible
Name private subnet 1&2, wordpress & rds
understand IAM - resource "aws_iam_policy" "lifecycle_policy" {
what does this do "amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2"


Remove db password from plain text




