# #!/bin/bash

# # Install Java JDK 1.8+ as a prerequisite for Tomcat to run.
# sudo hostnamectl set-hostname tomcat
# cd /opt 
# sudo yum install git wget -y
# sudo yum install java-1.8.0-openjdk-devel -y

# # Install MySQL GPG key
# sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# # Download MySQL repository RPM
# sudo wget http://dev.mysql.com/get/mysql57-community-release-e17-8.noarch.rpm

# # Install MySQL repository RPM
# sudo yum localinstall -y mysql57-community-release-e17-8.noarch.rpm

# # Install MySQL Community Server
# sudo yum install -y mysql-community-server

# # Start MySQL service
# sudo systemctl start mysqld

# # Enable MySQL service to start on boot
# sudo systemctl enable mysqld

# echo "MySQL installation and setup completed."

# # Install wget unzip packages.
# sudo yum install wget unzip -y

# # Download and extract Tomcat
# sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz 
# sudo tar -xvzf apache-tomcat-9.0.75.tar.gz
# sudo rm -rf apache-tomcat-9.0.75.tar.gz

# # Rename Tomcat for better naming convention
# sudo mv apache-tomcat-9.0.75/ tomcat9

# # Assign executable permissions to the Tomcat home directory
# sudo chmod 777 -R /opt/tomcat9
# sudo chown ec2-user -R /opt/tomcat9

# # Start Tomcat
# sh /opt/tomcat9/bin/startup.sh

# # Create soft links to start and stop Tomcat, enabling management as a service
# sudo ln -s /opt/tomcat9/bin/startup.sh /usr/bin/starttomcat
# sudo ln -s /opt/tomcat9/bin/shutdown.sh /usr/bin/stoptomcat
# starttomcat

# echo "End of Tomcat installation."
