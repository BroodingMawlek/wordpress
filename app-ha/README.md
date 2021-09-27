Pre requisites
Manually create wp_config_bucket S3 bucket in eu-west2 region and copy install_wp.sh to root.

Create a parameter called AmazonCloudWatch-linux in SSM Parameter store and copy the contents of AmazonCloudWatch-linux to the value   


Status
app-ha is referencing modules and working
Remote state is set
Solved IAM role for delivering CW logs is not working - was not enabled
Solved How to create and additional private subnet - Duplicated Private AZ
Solved - rds-mysql is working but creating db in default vpc, need to change to use the correct vpc and subnets
Solved - elb cert not found
Solved-  module.alb.target_group_arns is tuple with 1 element
Solved- Userdata configures apahe and wordpress wp-cpnfig fille
should be manually loaded into s3 and needs db hostname updated.


