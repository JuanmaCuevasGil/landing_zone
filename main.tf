# Creation of a S3 bucket with a randomly generated suffix and appended to the project name
module "mybucket" {
  source      = "./modules/s3"
  bucket_name = local.s3-sufix

}

# Creation of a number of instances defined in tfvars based on the quantity of names entered
module "myinstances" {
  source = "./modules/ec2"

  instance_name     = var.instance_name
  ec2_specs         = var.ec2_specs
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  key_name          = data.aws_key_pair.key.key_name
  public_sg_id      = module.network.public_security_group_id
  private_sg_id     = module.network.private_security_group_id
  enable_monitoring = var.enable_monitoring
  suffix            = local.suffix
}

# This module various parameters to the module, including cidr_map for IP addresses,
# suffix as a suffix, ingress_port_list for the list of incoming ports, and maps of
# protocols and ports with specific values for TCP and ports.
module "network" {
  source = "./modules/vpc"

  cidr_map = var.cidr_map

  suffix            = local.suffix
  ingress_port_list = var.ingress_port_list
  protocols         = var.protocols
  ports             = var.ports
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
}

module "zero_spend_budget" {
  source = "./budget_module"

  name                        = "ZeroSpendBudget"
  limit_amount                = "0.01"
  time_period_start           = "2023-01-01_00:00"
  time_period_end             = "2087-01-01_00:00"
  subscriber_email_addresses  = ["based@yopmail.com"]
}