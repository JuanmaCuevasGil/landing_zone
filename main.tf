# Creation of a S3 bucket with a randomly generated suffix and appended to the project name
module "mybucket" {
  source       = "./modules/s3"
  bucket_name  = local.s3-sufix
  instance_arn = module.myinstances.private_instance_arn
  config_time  = var.bucket_config

}

# Creation of a number of instances defined in tfvars based on the quantity of names entered
module "myinstances" {
  source = "./modules/ec2"

  instance_name     = var.instance_name
  ec2_specs         = var.ec2_specs
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  key_name          = var.key_name
  key_private_name  = var.key_private_name
  public_sg_id      = module.network.public_security_group_id
  private_sg_id     = module.network.private_security_group_id
  enable_monitoring = var.enable_monitoring
  suffix            = local.suffix
  key_pair_pem_public      = module.key_pair.key_pair_pem_public
  key_pair_pem_private = module.key_pair.key_pair_pem_private
  depends_on        = [module.key_pair]
  
}

# This module various parameters to the module, including cidr_map for IP addresses,
# suffix as a suffix, ingress_port_list for the list of incoming ports, and maps of
# protocols and ports with specific values for TCP and ports.
module "network" {
  source     = "./modules/vpc"
  cidr_map   = var.cidr_map
  suffix     = local.suffix
  ports      = var.ports
  private_ip = "${module.myinstances.private_ip["jumpserver"]}/32"
}

#Module for managing IAM groups.
module "iam_groups" {
  source     = "./modules/iam_groups"
  iam_groups = var.iam_groups
}

# Module for managing IAM users.
module "iam_users" {
  source     = "./modules/iam_users"
  iam_users  = var.iam_users
  iam_groups = var.iam_groups
  depends_on = [module.iam_groups]
}

# Module for setting up a budget with a $X.XX spending threshold, running from a date to another one. Notifications will be sent to email explicit.
module "zero_spend_budget" {
  source  = "./modules/budgets"
  budgets = var.budgets
}

# Module to store vpc logs in an S3 bucket
module "vpc_flow_logs" {
  source        = "./modules/vpc_flow_logs"
  s3_bucket_arn = module.mybucket.s3_bucket_arn
  vpc_id        = module.network.vpc_id
  depends_on    = [module.mybucket.s3_bucket_object]
}

# Module to generate key pair for access to the private instance
module "key_pair" {
  source             = "./modules/key_pair"
  algorithm_key_pair = var.algorithm_key_pair
  rsa_bits_key_pair  = var.rsa_bits_key_pair
  key_name_private   = var.key_private_name
  key_name = var.key_name
}

module "policy" {
  source         = "./modules/policy"
  s3_bucket_arn  = module.mybucket.s3_bucket_arn
  iam_group      = var.iam_groups
  depends_on     = [module.iam_groups]
  jumpserver_arn = module.myinstances.public_instance_arn["jumpserver"]
}

resource "local_file" "publickey" {
  content = module.key_pair.key_pair_pem_private
  filename = "./pem/SSH-Virginia.pem"
}

resource "local_file" "privatekey" {
  content = module.key_pair.key_pair_pem_private
  filename = "./pem/SSHP-Virginia.pem"
}