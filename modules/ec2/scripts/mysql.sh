#!/bin/bash
sudo su -
apt update -y
apt install mysql-server
systemctl start mysql
systemctl enable mysql