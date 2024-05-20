#output "ec2_public_ip" {
#  description = "Ip pública de la instancia"
#  value       = aws_instance.public_instance.public_ip
#}
output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}