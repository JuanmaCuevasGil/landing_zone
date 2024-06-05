locals {
  scripts = {
    apache     = <<-EOF
  #!/bin/bash
  sudo su -
  apt install apache2 -y
  systemctl enable apache2
  systemctl start apache2
  apt install firewalld -y
  firewall-cmd --zone=public --change-interface=eth0 --permanent
  firewall-cmd --zone=public --add-service=http --permanent
  firewall-cmd --zone=public --add-service=https --permanent
  firewall-cmd --reload
  EOF
    mysql      = <<-EOF
  #!/bin/bash
  sudo su -
  apt update -y
  apt install mysql-server
  systemctl start mysql
  systemctl enable mysql
  apt install firewalld -y
  firewall-cmd --zone=public --change-interface=eth0 --permanent
  firewall-cmd --zone=public --add-port=3306/tcp --permanent
  firewall-cmd --reload
  EOF
    monitoring = <<-EOF
  #!/bin/bash
  sudo su -
  apt update -y
  apt install awscli -y
  apt install firewalld -y
  firewall-cmd --zone=private --change-interface=eth0 --permanent
  firewall-cmd --zone=public --add-service=ssh --permanent
  firewall-cmd --reloads
  EOF
    jumpserver = <<-EOF
  #!/bin/bash
  sudo su -
  mkdir /.ssh
  echo "${var.key_pair_pem["private"].private_key_pem}" > /.ssh/${var.keys.key_name["private"]}.pem
  chmod 400 /.ssh/${var.keys.key_name["private"]}.pem
  echo "${var.key_pair_pem["vpn"].private_key_pem}" > /.ssh/${var.keys.key_name["vpn"]}.pem
  chmod 400 /.ssh/${var.keys.key_name["vpn"]}.pem
  chown -R ubuntu /.ssh
  ssh-keyscan -H ${var.vpn_ip} | sudo tee -a ~/.ssh/known_hosts
  apt update -y
  apt install firewalld -y
  apt install openvpn -y
  firewall-cmd --zone=public --change-interface=eth0 --permanent
  firewall-cmd --zone=public --add-service=ssh --permanent
  firewall-cmd --zone=public --add-service=openvpn --permanent
  firewall-cmd --reload
  scp -i /.ssh/${var.keys.key_name["vpn"]}.pem ubuntu@${var.vpn_ip}:/home/ubuntu/jumpserver.ovpn /home/ubuntu/
  openvpn --config /home/ubuntu/jumpserver.ovpn
  EOF
   vpn = <<-EOF
  EOF
  }
}

locals {
  filtered_ec2_specs = {
    for key, value in var.ec2_specs["instances"] :
    key => value
    if value != "vpn"
  }
}
