locals {
  vpn = <<-EOF
  #!/bin/bash
  sudo su -

  # Installation of the firewall and application of the rules
  apt install firewalld -y
  firewall-cmd --zone=public --change-interface=eth0 --permanent
  firewall-cmd --zone=public --add-service=openvpn --permanent
  firewall-cmd --zone=public --add-service=ssh --permanent
  firewall-cmd --zone=public --add-service=icmp --permanent
  firewall-cmd --zone=public --add-port=1194/udp --permanent
  firewall-cmd --zone=public --add-port=22/udp --permanent
  firewall-cmd --zone=public --add-port=22/tcp --permanent
  firewall-cmd --reload

  # Creation of the keys directory
  mkdir /.ssh

  # Insertion of the key in the directory, while applying the correct permissions and changing the owner
  echo "${var.key_pair_pem["monitoring"].private_key_pem}" > /.ssh/${var.keys.key_name["monitoring"]}.pem
  chmod 400 /.ssh/${var.keys.key_name["monitoring"]}.pem
  chown -R ubuntu /.ssh
  
  # We import an OpenVPN installer and apply execution permission
  curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
  chmod +x openvpn-install.sh

  # We set the correct parameters to make an automatic installation for the VPN server
  # Set the public IP address as endoint
  export ENDPOINT=$(curl http://checkip.amazonaws.com)
  # Set the client name
  export CLIENT=client
  # Enable the auto installation
  export AUTO_INSTALL=y

  # Execute the script
  ./openvpn-install.sh

  # We copy the generated file to an accesible directory, while changing file's ownership
  cp /root/client.ovpn /home/ubuntu
  chown ubuntu:ubuntu /home/ubuntu/client.ovpn
  EOF
}
