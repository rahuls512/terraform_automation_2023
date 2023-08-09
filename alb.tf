############# External Application Load Balancer ################################################################################################
resource "aws_lb" "this" {
  name               = "rsinfotech-alb"
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
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
############# Internal Application Load Balancer ################################################################################################
resource "aws_lb" "internal_alb" {
  name               = "internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
}
resource "aws_lb_target_group" "internal_target_group" {
  name     = "web-app-tg"
  port     = 80
  protocol = "HTTP"
}
resource "aws_autoscaling_group" "internal_asg" {
  name                 = "web-app-asg"
  desired_capacity     = 0  
  min_size             = 1
  max_size             = 1

  target_group_arns = [aws_lb_target_group.internal_target_group.arn]
}

resource "aws_lb_listener_rule" "internal_listener_rules" {
  listener_arn = aws_lb.internal_alb.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}