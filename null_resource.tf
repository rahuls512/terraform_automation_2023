resource "null_resource" "provisioner" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    always_run = timestamp()
  }
  depends_on = [aws_instance.bastion_host]

  #Connecting through a Bastion Host with SSH
  connection {
    host        = aws_instance.bastion_host.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.awskey01
  }

  #Provisioner-local to Automate the public access by using the SSH key for bostion host    
  #   provisioner "local-exec" {  
  #   command = "scp -o StrictHostKeyChecking=no -i ~/../Downloads/awskey5.pem ~/../Downloads/awskey5.pem ec2-user@${self.public_ip}:~"  
  #  } 
 
  #Provisioner-file to Automate the file by using the file path for bostion host 
  provisioner "file" {
      # source = "/../Downloads/awskey01.pem"
    content     = var.mykey
    destination = "/home/ec2-user/awskey01"
    on_failure  = continue

  }

  #Provisioner-file to Automate the keypair change modification by using the inline rule for bostion host 
  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/awskey01"
    ]
  }
}