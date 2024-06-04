variable "bucket_name" {
  description = "Nombre del bucket"
  type = string
}

variable "instance_arn" {
  description = "Instance ARN"
  type = string
}

variable "config_time"{
  description = "Days count to the rule bucket expiration"
  type = map(number)
}