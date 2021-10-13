#Prerequisites

RDS endpoint name mus be known before deployment, deploy the solution once and note the name.
Add the endpoint value to Secrets Manager then redeploy (see improvements)

Set Secrets in AWS Secrets Manager

WP Salts - DO NOT USE SPECIAL CHARACTERS - THE PHP PARSER CAN NOT HANDLE THEM

secret name = db-creds
```sh
username = Master RDS username	
password = Master RDS password	
dbname = rds db name
host = rds endpoint
AUTH_KEY = Create your own salt values, no special characters
SECURE_AUTH_KEY	= Create your own salt values, no special characters 
LOGGED_IN_KEY = Create your own salt values, no special characters    
NONCE_KEY =	Create your own salt values, no special characters        
AUTH_SALT =	Create your own salt values, no special characters        
SECURE_AUTH_SALT = Create your own salt values, no special characters 
LOGGED_IN_SALT = Create your own salt values, no special characters   
NONCE_SALT = Create your own salt values, no special characters       	
```

Create a parameter called AmazonCloudWatch-linux in SSM Parameter store and copy the contents of AmazonCloudWatch-linux to the value   

#Notes on Wordpress
wp-config.php is copied from Github using wget
This code will deploy Wordpress create and RDS MySQL database and configure wp-config.php. 
First time - Wordpress will then configuring by going to the Load Balancer dns name and entering details in the welcome page, after this the setup is written to the db and so persists.

#Notes on Secrets
Secrets have been managed using code from this site, secrets must be set in Secrets Manager manually.
https://www.rayheffer.com/aws-secrets-manager-for-wordpress-configuration/

#Deployment time
This solution takes around 10 mins to deploy the RDS database

#Manual steps
Must manually subscribe to sns topic

#Improvement
Add rds endpoint to secret manager or automate in some other way for wp-config.php

# Working on

##Backlog
Tag everything\
tighten asg security groups
Ensure variables are used where possible\




