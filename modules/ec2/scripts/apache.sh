#!/bin/bash
sudo apt update -y
sudo apt install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd