region = {
  "virginia" = "us-east-1"
}

cidr_map = {
  any      = "0.0.0.0/0"
  virginia = "10.10.0.0/16"
  public   = "10.10.0.0/24"
  private  = "10.10.1.0/24"
}

ports = {
  any     = { port = -1, protocol = "all" }
  default = { port = 0, protocol = "-1" }
  ssh     = { port = 22, protocol = "tcp" }
  http    = { port = 80, protocol = "tcp" }
  https   = { port = 443, protocol = "tcp" }
  icmp    = { port = 1, protocol = "icmp" }
}

tags = {
  "env"         = "dev"
  "owner"       = "JYJ"
  "cloud"       = "AWS"
  "IaC"         = "Terraform"
  "IaC_Version" = "1.5.7"
  "project"     = "landing-zone"
  "region"      = "virginia"
}

ec2_specs = {
  "ami"           = "ami-0bb84b8ffd87024d8"
  "instance_type" = "t2.micro"
}

instance_name = [
  "apache",
  "mysql",
  "jumpserver"
]

enable_monitoring = true

iam_users = {
  "admin_user"      = ["aws_admin"]
  "billing_user"    = ["aws_billing"]
  "security_user"   = ["aws_security"]
  "operations_user" = ["aws_operations"]
}

iam_groups = {
  "aws_admin"      = "arn:aws:iam::aws:policy/AdministratorAccess"
  "aws_billing"    = "arn:aws:iam::aws:policy/job-function/Billing"
  "aws_security"   = "arn:aws:iam::aws:policy/SecurityAudit"
  "aws_operations" = "arn:aws:iam::aws:policy/PowerUserAccess"
}
