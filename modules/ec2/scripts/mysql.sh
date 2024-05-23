#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb