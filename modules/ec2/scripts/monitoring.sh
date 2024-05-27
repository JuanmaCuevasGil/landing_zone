<<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install awscli -y
sudo apt install firewalld -y
sudo firewall-cmd --zone=private --change-interface=eth0 --permanent
sudo firewall-cmd --zone=public --add-service=ssh --permanent
sudo firewall-cmd --reload
EOF