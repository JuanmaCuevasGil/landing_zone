###############---- MODULE BUDGETS ----###############
# Module for setting up a budget with a $X.XX spending threshold, running from a date to another one. Notifications will be sent to email explicit.
module "zero_spend_budget" {
  source  = "./modules/BUDGETS"
  budgets = var.budgets
}

###############---- MODULE EC2 ----###############
# Creation of a number of instances defined in tfvars based on the quantity of names entered
module "myinstances" {
  source       = "./modules/EC2/ec2"
  ec2_specs    = var.ec2_specs
  subnet_ids   = module.network.subnet_ids
  keys         = var.keys
  sg_ids       = module.security_groups.sg_ids
  suffix       = local.suffix
  key_pair_pem = module.key_pair.key_pair_pem
  depends_on   = [module.key_pair, module.security_groups, module.vpn]
  vpn_ip = module.vpn.vpn_ip
}

module "vpn" {
  source = "./modules/EC2/ec2/vpn"
  ec2_specs    = var.ec2_specs
  subnet_ids   = module.network.subnet_ids
  keys         = var.keys
  sg_ids       = module.security_groups.sg_ids
  suffix       = local.suffix
  key_pair_pem = module.key_pair.key_pair_pem
}

# Module to generate key pair for access to the private instance
module "key_pair" {
  source = "./modules/EC2/key_pair"
  keys   = var.keys
}

# Module to create security groups
module "security_groups" {
  source     = "./modules/EC2/security_groups"
  ports      = var.ports
  vpc_ids    = module.network.vpc_ids
  cidr_map   = var.cidr_map
  private_ip = "0.0.0.0/0" #"${module.myinstances.private_ip["jumpserver"]}/32"
}

###############----MODULE IAM ----###############
#Module for managing IAM groups.
module "iam_groups" {
  source     = "./modules/IAM/iam_groups"
  iam_groups = var.iam_groups
}

# Module for managing IAM users.
module "iam_users" {
  source     = "./modules/IAM/iam_users"
  iam_users  = var.iam_users
  iam_groups = var.iam_groups
}
# Module for group policy
module "policy" {
  source         = "./modules/IAM/policy"
  s3_bucket_arn  = module.mybucket.s3_bucket_arn
  iam_group      = var.iam_groups
  jumpserver_arn = module.myinstances.instance_arns["jumpserver"]
  depends_on = [ module.iam_groups ]
}

###############---- MODULE S3 ----###############
# Creation of a S3 bucket with a randomly generated suffix and appended to the project name
module "mybucket" {
  source       = "./modules/S3"
  bucket_name  = local.s3-sufix
  instance_arn = module.myinstances.instance_arns["monitoring"]
  config_time  = var.bucket_config
}

###############---- MODULE VPC ----###############
# This module various parameters to the module, including cidr_map for IP addresses,
# suffix as a suffix, ingress_port_list for the list of incoming ports, and maps of
# protocols and ports with specific values for TCP and ports.
module "network" {
  source              = "./modules/VPC/vpc"
  cidr_map            = var.cidr_map
  suffix              = local.suffix
  ports               = var.ports
}

# Module to store vpc logs in an S3 bucket
module "vpc_flow_logs" {
  source        = "./modules/VPC/vpc_flow_logs"
  s3_bucket_arn = module.mybucket.s3_bucket_arn
  vpc_id        = module.network.vpc_ids["virginia"]
  depends_on    = [module.mybucket]
}
