#!/bin/bash
sudo apt update -y
sudo apt install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
sudo apt install firewalld -y
sudo firewall-cmd --zone=public --change-interface=eth0 --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --reload