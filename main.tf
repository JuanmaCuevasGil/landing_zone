###############---- MODULE BUDGETS ----###############
# Module for setting up a budget with a $X.XX spending threshold, running from a date to another one. Notifications will be sent to email explicit.
module "zero_spend_budget" {
  source  = "./modules/BUDGETS"
  budgets = var.budgets
}

###############---- MODULE EC2 ----###############
# Creation of a number of instances defined in tfvars based on the quantity of names entered
module "myinstances" {
  source = "./modules/EC2/ec2"
  instance_name     = var.instance_name
  ec2_specs         = var.ec2_specs
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  keys              = var.keys
  public_sg_id      = module.security_groups.pub_sg_virginia_id
  private_sg_id     = module.security_groups.priv_sg_virginia_id
  enable_monitoring = var.enable_monitoring
  suffix            = local.suffix
  key_pair_pem      = module.key_pair.key_pair_pem
  depends_on        = [module.key_pair, module.security_groups]
}
# Module to generate key pair for access to the private instance
module "key_pair" {
  source = "./modules/EC2/key_pair"
  keys   = var.keys
}
# Module to create security groups
module "security_groups" {
  source = "./modules/EC2/security_groups"
  ports      = var.ports
  vpc_virginia_id = module.network.vpc_id
  vpn_id = module.network.vpn_id
  cidr_map   = var.cidr_map
  private_ip = "0.0.0.0/0"
}

###############----MODULE IAM ----###############
#Module for managing IAM groups.
module "iam_groups" {
  source     = "./modules/IAM/iam_groups"
  iam_groups = var.iam_groups
  depends_on = [ module.iam_users ]
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
  jumpserver_arn = module.myinstances.public_instance_arns["jumpserver"]
}

###############---- MODULE S3 ----###############
# Creation of a S3 bucket with a randomly generated suffix and appended to the project name
module "mybucket" {
  source       = "./modules/S3"
  bucket_name  = local.s3-sufix
  instance_arn = module.myinstances.monitoring_instance_arn
  config_time  = var.bucket_config
}

###############---- MODULE VPC ----###############
# This module various parameters to the module, including cidr_map for IP addresses,
# suffix as a suffix, ingress_port_list for the list of incoming ports, and maps of
# protocols and ports with specific values for TCP and ports.
module "network" {
  source     = "./modules/VPC/vpc"
  cidr_map   = var.cidr_map
  suffix     = local.suffix
  ports      = var.ports
  private_ip = "${module.myinstances.private_ip["jumpserver"]}/32"
  sg_vpn_id = module.security_groups.sg_vpn_id
  pub_sg_virginia_id = module.security_groups.pub_sg_virginia_id
  priv_sg_virginia_id = module.security_groups.priv_sg_virginia_id
}
# Module to store vpc logs in an S3 bucket
module "vpc_flow_logs" {
  source        = "./modules/VPC/vpc_flow_logs"
  s3_bucket_arn = module.mybucket.s3_bucket_arn
  vpc_id        = module.network.vpc_id
  depends_on = [ module.mybucket ]
}