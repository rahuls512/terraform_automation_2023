########### Web-server image ################################################################################################
source "amazon-ebs" "this" {
  assume_role {
    role_arn     = "arn:aws:iam::640111764884:role/stsassume-role"
    session_name = "packer-session"
  }
  region        = var.region
  source_ami    = "ami-008b85aa3ff5c1b02"
  instance_type = var.instance_type
  ssh_username  = var.ssh_user_name
  ami_name      = local.image_name
}

build {
  sources = [
    "source.amazon-ebs.this"
  ]

  provisioner shell {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo echo '<h1>Welcome to rsinfotech.com</h1>'|sudo tee /var/www/html/index.html"
    ]
  }
}