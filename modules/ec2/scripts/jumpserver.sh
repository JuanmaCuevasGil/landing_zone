#!/bin/bash
sudo mkdir .ssh
sudo echo "${var.key_pair_pem}" > /.ssh/${var.key_private_name}.pem
sudo chmod 400 .ssh/${var.key_private_name}.pem
sudo apt update -y
sudo apt install firewalld -y
sudo firewall-cmd --zone=public --change-interface=eth0 --permanent
sudo firewall-cmd --zone=public --add-service=ssh --permanent
sudo firewall-cmd --reload
