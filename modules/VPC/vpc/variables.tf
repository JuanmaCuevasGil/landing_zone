variable "cidr_map" {
  description = "Map of CIDR blocks for VPC, subnets, etc."
  type        = map(string)
}