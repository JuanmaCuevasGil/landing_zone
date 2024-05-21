module "mybucket" {
  source      = "./modules/s3"
  bucket_name = local.s3-sufix

}

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

resource "aws_flow_log" "example" {
  log_destination      = module.mybucket.s3_bucket_arn_vpc
  traffic_type         = "ALL"
  vpc_id               = module.network.vpc_id
  log_destination_type = "s3"
  log_format = "$${version} $${vpc-id}"
}
