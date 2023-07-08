############# Bastion Host Server ################################################################################################
resource "aws_instance" "bastion_host" {
  ami           = var.images
  instance_type = var.instance_types
  key_name      = var.key_name
  subnet_id     = element([for each_subnet in aws_subnet.public_subnet : each_subnet.id], 0)

  tags = {
    Name = local.bastion_host
  }
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
}
############# Bastion Host Security group ################################################################################################
resource "aws_security_group" "bastion_host" {
  name        = "Bastion-Host-SG"
  description = "Allow ssh traffic into private subnet resource using this"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow ssh to bastion host from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-sg-allow"
  }
}
