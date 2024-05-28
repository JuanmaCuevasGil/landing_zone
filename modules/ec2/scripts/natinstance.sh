#!/bin/bash
sudo su -
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
