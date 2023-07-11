############# RDS Instance ################################################################################################
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "threetierdb"
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t3.micro"
  username               = var.db_user_name
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.this.id
}
############# RDS Instance Subnet Group ################################################################################################
resource "aws_db_subnet_group" "this" {
  name       = "threetierdb_subnet_group"
  subnet_ids = [for each_subnet in aws_subnet.private_subnet : each_subnet.id]

  tags = {
    Name = "rsinfotech DB subnet group"
  }
}