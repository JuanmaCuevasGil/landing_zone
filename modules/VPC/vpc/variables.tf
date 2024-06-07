variable "cidr_map" {
  description = "Map of CIDR blocks for VPC, subnets, etc."
  type        = map(string)
}

variable "vpcs" {
  type = map(string)
}

variable "subnets" {
  type = map(object({
    vpc  = string
    cidr = string
  }))
}