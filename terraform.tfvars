estocolmo_cidr = "10.10.0.0/16"
/* public_subnet = "10.10.0.0/24"
private_subnet = "10.10.1.0/24" */

subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"         = "dev"
  "owner"       = "Jacobo"
  "cloud"       = "AWS"
  "IaC"         = "Terraform"
  "IaC_Version" = "1.5.7"
  "project"     = "cerberus"
  "region"      = "estocolmo"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami"           = "ami-0a63bd9c44af62f91"
  "instance_type" = "t3.micro"
}

instancias = ["apache", "mysql", "jumpserver"]

enable_monitoring = 0

ingress_port_list = [ 22, 80 , 443 ]