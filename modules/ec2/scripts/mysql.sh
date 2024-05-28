#!/bin/bash
sudo apt update -y
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
sudo apt install firewalld -y
sudo firewall-cmd --zone=public --change-interface=eth0 --permanent
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload