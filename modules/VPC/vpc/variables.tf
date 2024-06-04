variable "cidr_map" {
  description = "Map of CIDR blocks for VPC, subnets, etc."
  type        = map(string)
}

variable "suffix" {
  description = "Suffix to append to resource names"
  type        = string
}

variable "ports" {
  description = "Map of ports used in security group"
  type = map(object({
    port     = number
    protocol = string
  }))
}

variable "private_ip" {
  description = "Private IP of jumpserver"
  type = string
}

variable "sg_vpn_id" {
  description = "Security Group VPN"
  type = string
}

variable "pub_sg_virginia_id" {
  description = "ID Public Security Group Virginia"
  type = string
}

variable "priv_sg_virginia_id" {
  description = "ID Public Security Group Virginia"
  type = string
}
