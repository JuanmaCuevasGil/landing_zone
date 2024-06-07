# Creation of the specific vpn out from the loop because of the needs to exist to launch the other instances user datas
resource "aws_instance" "vpn" {
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.type
  subnet_id              = var.subnet_ids["vpn"]
  key_name               = var.keys.key_name["vpn"]
  vpc_security_group_ids = [var.sg_ids["vpn"]]
  user_data              = local.vpn
  associate_public_ip_address = true
  tags = {
    "Name" = "${"vpn"}"
  }
}