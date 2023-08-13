############# Web Server ################################################################################################
resource "aws_instance" "web" {
  ami           = data.aws_ami.this.id # reference from the data_source.tf for use packer image(redhatbase-apache-image)
  instance_type = var.instance_types
  key_name      = var.key_name
  subnet_id     = element([for each_subnet in aws_subnet.private_subnet : each_subnet.id], 0)

  tags = {
    Name = local.web_server
  }
  vpc_security_group_ids = [aws_security_group.web.id]
  #   user_data              = file("${path.module}/user_data.sh") #commentout bcz we are not use user_data.tf here
}