variable "instance_name" {
  description = "Names for the public instances"
  type        = set(string)
}

variable "ec2_specs" {
  description = "EC2 specifications including AMI and instance type"
  type = object({
    ami            = string
    instance_type  = string
  })
}

variable "subnet_id" {
  description = "Subnet ID where instances will be launched"
  type        = string
}

variable "key_name" {
  description = "Key pair name to access instances"
  type        = string
}

variable "sg_id" {
  description = "Security group ID to associate with instances"
  type        = string
}

variable "enable_monitoring" {
  description = "Enable or disable monitoring instance"
  type        = bool
}

variable "suffix" {
  description = "Suffix to append to instance names"
  type        = string
}