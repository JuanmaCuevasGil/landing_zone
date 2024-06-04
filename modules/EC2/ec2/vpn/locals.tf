locals {
  vpn = <<-EOF
  #!/bin/bash
  sudo su -
  mkdir /.ssh
  echo "${var.key_pair_pem["private"].private_key_pem}" > /.ssh/${var.keys.key_name["private"]}.pem
  chmod 400 ~/${var.keys.key_name["private"]}.pem
  curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
  chmod +x openvpn-install.sh
  export ENDPOINT=$(curl http://checkip.amazonaws.com)
  export CLIENT=jumpserver
  export AUTO_INSTALL=y
  ./openvpn-install.sh
  cp /root/jumpserver.ovpn /home/ubuntu
  EOF
}