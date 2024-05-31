variable "region" {
  description = "Región"
  type        = map(string)
}

variable "cidr_map" {
  description = "CIDR map"
  type        = map(string)
}

variable "ports" {
  type = map(object({
    port     = number
    protocol = string
  }))
  description = "Ports & Protocols"
}

variable "tags" {
  description = "value"
  type        = map(string)
}

variable "ec2_specs" {
  description = "Parameters of the instance"
  type        = map(string)
}

variable "instance_name" {
  description = "Name of the instances"
  type        = set(string)
}

variable "enable_monitoring" {
  description = "Enables the deployment of monitoring"
  type        = bool
}

variable "iam_users" {
  description = "Usuarios IAM"
  type        = map(set(string))
}

variable "iam_groups" {
  description = "Mapa de los grupos"
  type = list(string)
}

variable "bucket_config" {
  description = "Configuration values of the bucket lifecycle"
  type        = map(number)
}

variable "budget_config" {
  description = "Configuration values of the budget"
  type = object({
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
  })
}

variable "access_key" {
  description = "Access key for Terraform Cloud"
}

variable "secret_key" {
  description = "Secret key for Terraform Cloud"
}

variable "keys" {
  description = "Valores para configurar nuestra generación de keys"
  type = object({
    algorithm = string 
    rsa_bits = number
    key_name = map(string)
  })
}