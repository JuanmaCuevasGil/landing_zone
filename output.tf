<<<<<<< HEAD
=======
output "ec2_public_ip" {
 description = "Ip pública de la instancia"
 value       = module.myinstances.public_instance_ids
}
>>>>>>> c0c6dccb6e6705b02e4e62756ec42ce8ebd4755c
output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}