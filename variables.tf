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
    port      = number
    protocol  = string
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

variable "ingress_port_list" {
  description = "Lista de puertos de ingress"
  type        = map(object({
    port      = number
    protocol  = string
  }))
}

variable "iam_users" {
  description = "Usuarios IAM"
  type = map(set(string))
}

variable "iam_groups" {
  description = "Mapa de los grupos"
  type = map(string)
}
