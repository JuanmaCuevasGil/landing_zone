locals {
  vpn = <<-EOF
  #!/bin/bash
  sudo su -
  apt install firewalld -y
  firewall-cmd --zone=public --change-interface=eth0 --permanent
  firewall-cmd --zone=public --add-service=openvpn --permanent
  firewall-cmd --zone=public --add-service=ssh --permanent
  firewall-cmd --zone=public --add-service=icmp --permanent
  firewall-cmd --zone=public --add-port=1194/udp --permanent
  firewall-cmd --zone=public --add-port=22/udp --permanent
  firewall-cmd --zone=public --add-port=22/tcp --permanent
  firewall-cmd --reload
  mkdir /.ssh
  echo "${var.key_pair_pem["public"].private_key_pem}" > /.ssh/${var.keys.key_name["public"]}.pem
  chmod 400 /.ssh/${var.keys.key_name["public"]}.pem
  chown -R ubuntu /.ssh
  curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
  chmod +x openvpn-install.sh
  export ENDPOINT=$(curl http://checkip.amazonaws.com)
  export CLIENT=jumpserver
  export AUTO_INSTALL=y
  ./openvpn-install.sh
  cp /root/jumpserver.ovpn /home/ubuntu
  chown ubuntu:ubuntu /home/ubuntu/jumpserver.ovpn
  EOF
}
