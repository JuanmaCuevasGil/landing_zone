#!/bin/bash
apt update -y
apt install awscli -y
apt install firewalld -y
firewall-cmd --zone=private --change-interface=eth0 --permanent
firewall-cmd --zone=public --add-service=ssh --permanent
firewall-cmd --reloads