#Description
This code will deploy Wordpress create an RDS MySQL database and configure wp-config.php.
On first use Wordpress will need configuring by going to the Load Balancer dns name and entering details in the welcome page, after this the setup is written to the db and so persists.

#Prerequisites

Terraform version 0.12.21

Create an S3 bucket for the Terraform state file named "state-byoi-<your-aws-acc-number>"
Use bucket creation defaults ensuring that "Block public access" is selected
Enter bucket name in main.tf

Create Secrets in AWS Secrets Manager - choose "Other type of secrets" if using the console
DO NOT USE SPECIAL CHARACTERS in WP-Salts - THE PHP PARSER CAN NOT HANDLE THEM
Use https://passwordsgenerator.net/ to generate the 8 x 64 character strings using letters and numbers only

secret name = db-creds
```sh
username = your choice of Master RDS username	
password = your choice of Master RDS password	
dbname = your choice RDS db name
host = leave this blank as not known yet
AUTH_KEY = Create your own salt values, no special characters
SECURE_AUTH_KEY	= Create your own salt values, no special characters 
LOGGED_IN_KEY = Create your own salt values, no special characters    
NONCE_KEY =	Create your own salt values, no special characters        
AUTH_SALT =	Create your own salt values, no special characters        
SECURE_AUTH_SALT = Create your own salt values, no special characters 
LOGGED_IN_SALT = Create your own salt values, no special characters   
NONCE_SALT = Create your own salt values, no special characters       	
```

Terraform init
Terraform apply

lb_dns_name is output by TF, navigating to that will give "Error establishing a database connection"
Copy RDS endpoint from TF output and add it to db-creds/host (ommit:3306)
e.g. wp-rds.donotusethis123.eu-west-2.rds.amazonaws.com

Terminate all running instances, the ASG will deploy new instances which will pick up the RDS endpoint from Secrets Manager.

Connect to the alb dns name again and configure the details for WordPress, these are stored in the db and so persist across all instances created by the ASG.

Manually subscribe to sns topic


#Notes on Secrets
Secrets have been managed using code from this site, secrets must be set in Secrets Manager manually.
https://www.rayheffer.com/aws-secrets-manager-for-wordpress-configuration/

#Deployment time
This solution takes around 10 mins to deploy the RDS database


#Improvement
Add rds endpoint to secret manager or automate in some other way. We have a chicken and egg situation where the endpoint name is needed for wp-config.php, but we do not have it until the RDS instance is deployed.


##Learning
Initially I left this site deployed and waiting to be set up on the wp-admin/install.php page.
The site was then hacked as bots scan for that page and config db details to take control.
This is explained here https://www.wordfence.com/blog/2017/07/wpsetup-attack/


A possible solution is to finish WordPress setup via scripts and not leave the site open to wp-admin/install.php alternatively abandon this method.