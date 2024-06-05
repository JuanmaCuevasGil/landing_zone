# We indicate the IDs of the instances, for each generated instance, we return its ARN by accessing it through its name
output "instance_arns" {
  value = {
    for key, instance in aws_instance.instances :
    key => instance.arn
  }
}
