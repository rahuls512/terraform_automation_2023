#!/bin/bash
# package updates
sudo yum check-update
sudo yum update 
# apache installation, enabling, start and status check
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
#Upload the text to Doc root index.html 
sudo echo '<h1>Welcome to rsinfotech </h1>|sudo tee /var/www/html/index.html