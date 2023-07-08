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
############# Web Server Security group ####################################################################################
resource "aws_security_group" "web" {
  name        = "web_server-SG"
  description = "Allow web  traffic"
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.inbound_rules_web
    content {
      description = ingress.value.description
      protocol    = ingress.value.protocol
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      cidr_blocks = [aws_vpc.this.cidr_block]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_server-sg-allow"
  }
}
