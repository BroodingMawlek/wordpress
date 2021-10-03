#Prerequisites
Manually create wp_config_bucket S3 bucket in eu-west2 region and copy wp-config.php to root.
Bucket name in app-ha/install_wp.sh must be correct

Create a parameter called AmazonCloudWatch-linux in SSM Parameter store and copy the contents of AmazonCloudWatch-linux to the value   

#Notes
Outputs are specified in the module and in the code e.g.
app-ha/outputs.tf

output wp_private_subnets {
  description = "IDs of the Application VPC's private subnets"
  value       = module.vpc.private_subnets
}
#Deployment time
This solution takes around 20 mins to deploy the RDS database

#Status
Solved app-ha is referencing modules and working\
Solved Remote state is set\
Solved IAM role for delivering CW logs is not working - was not enabled\
Solved How to create additional private subnet - Duplicated Private AZ\
Solved rds-mysql is working but creating db in default vpc, need to change to use the correct vpc and subnets\
Solved elb cert not found\
Solved module.alb.target_group_arns is tuple with 1 element\
Solved Userdata configures apache and wordpress wp-cpnfig file\
Solved db hostname needs to be updated before wp will work, workaround is to deploy code, get hostname, edit wp-config.php and re-deploy instances in asg.

#Manual steps
Must manually subscribe to sns topic

#Improvement
Tag everything
Make db hostname available as an output and automate deployment
Automate uploading of AmazonCloudWatch-linux to ssm
tighten security groups
Ensure variables are used where possible
Name private subnet 1&2, wordpress & rds
understand IAM - resource "aws_iam_policy" "lifecycle_policy" {
what does this do "amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2"


Remove db password from plain text




