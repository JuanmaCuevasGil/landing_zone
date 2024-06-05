variable "region" {
  description = "Region"
  type        = map(string)
}

variable "cidr_map" {
  description = "CIDR map"
  type        = map(string)
}

variable "ports" {
  type = map(object({
    ingress = map(object({
      from_port = number
      to_port   = number
      protocol  = string
    }))
    egress = object({
      from_port = number
      to_port   = number
      protocol  = string
    })
  }))
  description = "Ports & Protocols"
}

variable "tags" {
  description = "Generally tags"
  type        = map(string)
}

variable "ec2_specs" {
  description = "Parameters of the instances"
  type = object({
    ami       = string
    type      = string
    instances = map(string)
  })
}

variable "iam_users" {
  description = "Users map and their assignments"
  type        = map(set(string))
}

variable "iam_groups" {
  description = "Groups map"
  type        = list(string)
}

variable "bucket_config" {
  description = "Configuration values of the bucket lifecycle"
  type        = map(number)
}

# variable "access_key" {
#   description = "Access key for Terraform Cloud"
# }

# variable "secret_key" {
#   description = "Secret key for Terraform Cloud"
# }

variable "budgets" {
  description = "List of budgets and their configurations"
  type = list(object({
    budget_name              = string
    budget_limit_amount      = string
    budget_time_period_start = string
    budget_time_period_end   = string
    budget_notifications = list(object({
      comparison_operator               = string
      notification_type                 = string
      threshold                         = number
      threshold_type                    = string
      budget_subscriber_email_addresses = list(string)
    }))
  }))
}

variable "keys" {
  description = "Valores para configurar nuestra generación de keys"
  type = object({
    algorithm = string
    rsa_bits  = number
    key_name  = map(string)
  })
}
