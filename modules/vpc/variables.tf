variable "cidr_map" {
  description = "Map of CIDR blocks for VPC, subnets, etc."
  type = map(string)
}

variable "suffix" {
  description = "Suffix to append to resource names"
  type        = string
}

variable "ingress_port_list" {
  description = "List of ingress ports for the security group"
  type        = list(number)
}

variable "protocols" {
  description = "Map of protocols used in security group"
  type = map(string)
}

variable "ports" {
  description = "Map of ports used in security group"
  type = map(number)
}