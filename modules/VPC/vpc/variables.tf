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