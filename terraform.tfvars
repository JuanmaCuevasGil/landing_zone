region = {
  "virginia" = "us-east-1"
}

cidr_map = {
  any        = "0.0.0.0/0"
  virginia   = "10.10.0.0/16"
  vpn        = "10.20.0.0/16"
  public     = "10.10.1.0/24"
  private    = "10.10.2.0/24"
  vpn_subnet = "10.20.1.0/24"
}

#Cambiar los puertos para añadir 3 variables
ports = {
  public = {
    ingress = {
      icmp = {
        from_port = -1
        to_port   = -1
        protocol  = "icmp"
      }
      ssh = {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
      }
      http = {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
      }
      https = {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
      }
    }
    egress = {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
    }
  }
  private = {
    ingress = {
      ssh = {
        from_port = 22,
        to_port   = 22,
        protocol  = "tcp"
      }
    }
    egress = {
      from_port = 0,
      to_port   = 0,
      protocol  = "-1"
    }
  }
  vpn = {
    ingress = {
      all = {
        from_port = 0,
        to_port   = 65535,
        protocol  = "tcp"
      },
      icmp = {
        from_port = -1,
        to_port   = -1,
        protocol  = "icmp"
      }
    }
    egress = {
      from_port = 0,
      to_port   = 0,
      protocol  = "-1"
    }
  }
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
  ami  = "ami-0e001c9271cf7f3b9"
  type = "t2.micro"
  instances = {
    apache     = "public"
    mysql      = "public"
    jumpserver = "public"
    monitoring = "private"
    vpn        = "vpn"
  }
}

iam_users = {
  "admin_user"      = ["aws_admin"]
  "billing_user"    = ["aws_billing"]
  "security_user"   = ["aws_security"]
  "operations_user" = ["aws_operations"]
}

iam_groups = [
  "aws_admin",
  "aws_billing",
  "aws_security",
  "aws_operations"
]

keys = {
  algorithm = "RSA"
  rsa_bits  = 4096
  key_name = {
    public  = "SSH-Virginia-Public"
    private = "SSH-Virginia-Private"
    vpn     = "SSH-Virginia-VPN"
  }
}

bucket_config = {
  expiration  = 90
  glacier     = 60
  standard_ia = 30
}

budgets = [
  {
    budget_name              = "ZeroSpendBudget"
    budget_limit_amount      = "1.00"
    budget_time_period_start = "2023-01-01_00:00"
    budget_time_period_end   = "2087-01-01_00:00"
    budget_notifications = [{
      comparison_operator               = "GREATER_THAN"
      notification_type                 = "ACTUAL"
      threshold                         = 10
      threshold_type                    = "PERCENTAGE"
      budget_subscriber_email_addresses = ["based@yopmail.com"]
      }, {
      comparison_operator               = "GREATER_THAN"
      notification_type                 = "ACTUAL"
      threshold                         = 0.01
      threshold_type                    = "ABSOLUTE_VALUE"
      budget_subscriber_email_addresses = ["based@yopmail.com"]
    }]
  },
  {
    budget_name              = "AnotherBudget"
    budget_limit_amount      = "500.00"
    budget_time_period_start = "2023-01-01_00:00"
    budget_time_period_end   = "2087-01-01_00:00"
    budget_notifications = [{
      comparison_operator               = "GREATER_THAN"
      notification_type                 = "ACTUAL"
      threshold                         = 50
      threshold_type                    = "PERCENTAGE"
      budget_subscriber_email_addresses = ["another@yopmail.com"]
    }]
  }
]
