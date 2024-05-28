variable "suffix" {
  description = "Suffix to append to resource names"
  type        = string
}

variable "cidr_map" {
  description = "Map of CIDR blocks for VPC, subnets, etc."
  type        = map(string)
}

variable "subnet_id" {
  description = "Id of the public and private subnets"
  type = map(string)
}

variable "network_interface_id" {
  description = "Id of the Nat Instance"
  type = string
}

variable "ig_id" {
  description = "Id for the Internet GateWay"
  type = string
}

variable "vpc_id" {
  description = "Id for the VPC"
  type = string
}