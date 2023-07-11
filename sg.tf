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
############# Application Server Security Group ####################################################################################
resource "aws_security_group" "application_server" {
  name   = "allow_application_traffic"
  vpc_id = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.inbound_rules_application
    content {
      description     = ingress.value.description
      protocol        = ingress.value.protocol
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      security_groups = [aws_security_group.web.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_app_server"
  }
}
############# Application Load Balancer Security Group ####################################################################################
resource "aws_security_group" "lb_sg" {
  name        = "allow_lb"
  description = "Allow access to load balancer from internet"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow access to load balancer from internet"
    from_port   = 80
    to_port     = 80
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
    Name = "allow_alb_sg"
  }
}
############# RDS Security Group ####################################################################################
resource "aws_security_group" "db_sg" {
  name        = "allow_db"
  description = "Allow access to db from app server"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Allow access to db from app server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.application_server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_db_sg"
  }
}