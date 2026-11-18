resource "aws_lb_target_group" "app_tg" {

  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
  }
}
resource "aws_lb" "app_alb" {

  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_sg_id
  ]

  subnets = [
    var.public_subnet1_id,
    var.public_subnet2_id
  ]
}
resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.app_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}