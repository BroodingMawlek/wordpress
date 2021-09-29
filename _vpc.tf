# Terraform configuration
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "state-byoi--822101501359"
    key    = "terraform-remote-state"
    region = "eu-west-2"
  }
}

module "vpc" {
  source = "./modules/vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs               = var.vpc_azs
  private_subnets   = var.wp_private_subnets
  private_subnets_2 = var.vpc_private_subnets_2
  public_subnets    = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
#  create_igw = enable

  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role

  tags = var.vpc_tags
}

