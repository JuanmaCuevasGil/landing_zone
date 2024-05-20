module "mybucket" {
  source      = "./modules/s3"
  bucket_name = local.s3-sufix
}

module "myinstances" {
  source = "./modules/ec2"

  instance_name       = var.instance_name
  ec2_specs           = var.ec2_specs
  subnet_id           = module.network.public_subnet_id
  key_name            = data.aws_key_pair.key.key_name
  sg_id               = module.network.public_security_group_id
  enable_monitoring   = var.enable_monitoring
  suffix              = local.suffix
}

module "network" {
  source = "./modules/vpc"

  cidr_map = var.cidr_map

  suffix            = local.suffix
  ingress_port_list = var.ingress_port_list
  protocols = {
    tcp = var.protocols["tcp"]
    any = var.ports["any"]
  }

  ports = {
    socket = var.ports["socket"]
    any    = var.ports["any"]
  }
}
