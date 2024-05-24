#!/bin/bash
sudo apt update -y
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
