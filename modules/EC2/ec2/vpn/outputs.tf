output "vpn_ip" {
  description = "Sending out to the my instance module to use the ip in bootstraps"
  value = aws_instance.vpn.public_ip
}

output "vpn_arn" {
  description = "Sending out to the my instance module to use the ip in bootstraps"
  value = aws_instance.vpn.arn
}