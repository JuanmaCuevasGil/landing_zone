output "sg_vpn_id" {
  value = aws_security_group.virginia_vpn.id
}

output "pub_sg_virginia_id" {
  value = aws_security_group.public_instance.id
}

output "priv_sg_virginia_id" {
  value = aws_security_group.private_instance.id
}