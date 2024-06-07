###############----MODULE IAM Groups----###############
#Module for managing IAM groups.
module "iam_groups" {
  source     = "./modules/IAM/iam_groups"
  iam_groups = var.iam_groups
}

###############----MODULE IAM Users----###############
# Module for managing IAM users.
module "iam_users" {
  source     = "./modules/IAM/iam_users"
  iam_users  = var.iam_users
  iam_groups = var.iam_groups

}

###############----MODULE Policy----###############
# Module to store and assign policies
module "policy" {
  source         = "./modules/IAM/policy"
  s3_bucket_arn  = module.mybucket.s3_bucket_arn
  iam_group      = var.iam_groups
  monitoring_arn = module.myinstances.instance_arns["monitoring"]
  depends_on = [ module.iam_groups ]
}

###############---- MODULE VPC ----###############
# This module various parameters to the module, including cidr_map for IP addresses
# and create the respective subnets to assign our instances
module "network" {
  source              = "./modules/VPC/vpc"
  cidr_map            = var.cidr_map
  vpcs = var.vpcs
  subnets = var.subnets
}

###############---- MODULE Security Groups ----###############
# Module to dynamically create security groups based on the ports variable
module "security_groups" {
  source     = "./modules/EC2/security_groups"
  ports      = var.ports
  vpc_ids    = module.network.vpc_ids
  cidr_map   = var.cidr_map
}

###############---- MODULE EC2 ----###############
# Creation and assignment to subnets and security groups dynamically based
# on the ec2_specs variable in terraform.tfvars.
module "myinstances" {
  source       = "./modules/EC2/ec2"
  ec2_specs    = var.ec2_specs
  subnet_ids   = module.network.subnet_ids
  keys         = var.keys
  sg_ids       = module.security_groups.sg_ids
  key_pair_pem = module.key_pair.key_pair_pem
  depends_on   = [module.key_pair, module.security_groups, module.vpn]
  vpn_ip = module.vpn.vpn_ip
}

###############---- MODULE VPN ----###############
# Creation of the instance configured with openvpn separately from the others 
# to first generate its bootstrap so that clients can download it without problem.
module "vpn" {
  source = "./modules/EC2/ec2/vpn"
  ec2_specs    = var.ec2_specs
  subnet_ids   = module.network.subnet_ids
  keys         = var.keys
  sg_ids       = module.security_groups.sg_ids
  key_pair_pem = module.key_pair.key_pair_pem
}

###############---- MODULE Key Pair ----###############
# Module to generate key pair for access to the private instance
module "key_pair" {
  source = "./modules/EC2/key_pair"
  keys   = var.keys
}

###############---- MODULE S3 ----###############
# Creation of a S3 bucket with a randomly generated suffix used for flow logs
module "mybucket" {
  source       = "./modules/S3"
  bucket_name  = local.s3-sufix
  instance_arn = module.myinstances.instance_arns["monitoring"]
  config_time  = var.bucket_config
}

###############---- MODULE Flow Logs ----###############
# Module to store vpc logs in an S3 bucket
module "flow_logs" {
  source        = "./modules/VPC/flow_logs"
  s3_bucket_arn = module.mybucket.s3_bucket_arn
  vpc_id        = module.network.vpc_ids
  depends_on    = [module.mybucket]
}

###############---- MODULE BUDGETS ----###############
# Module for setting up a budget with a $X.XX spending threshold, running 
# from a date to another one. Notifications will be sent to email explicit.
# Change data in terraform.tfvars
module "zero_spend_budget" {
  source  = "./modules/BUDGETS"
  budgets = var.budgets
}