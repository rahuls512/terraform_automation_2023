############# Internet facing Application Load Balancer ################################################################################################
resource "aws_lb" "this" {
  name               = "rsinfotech-internetFacing-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for each_subnet in aws_subnet.public_subnet : each_subnet.id]
}

############# Target group ALB ################################################################################################
resource "aws_lb_target_group" "this" {
  name     = "rsinfotech-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.web.id
  port             = 80
}

############# Listener ALB  ################################################################################################
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

############# Internal facing Application Load Balancer ######################################################################
resource "aws_lb" "i_alb" {
  name               = "rsinfotech-internalFacing-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id, aws_security_group.application_server.id]
  subnets            = [for each_subnet in aws_subnet.private_subnet : each_subnet.id]
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    protocol = "HTTP"
    port     = "traffic-port"
  }
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "app-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    protocol = "HTTP"
    port     = "traffic-port"
  }
}
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.i_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.i_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}