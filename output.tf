output "ec2_public_ip" {
 description = "Ip pública de la instancia"
 value       = module.myinstances.public_instance_ids
}
output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}