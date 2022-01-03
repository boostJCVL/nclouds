resource "aws_lb" "nlb" {
  name = "carlos-tf-lb"
  internal = false
  load_balancer_type = "network"
  subnets = var.subnets
}

resource "aws_lb_target_group" "tg" {
  name = "carlos-tf-tg"
  port = 80
  protocol = "TCP"
  vpc_id = var.vpc 
}

resource "aws_lb_listener" "front" {
  load_balancer_arn = aws_lb.nlb.arn
  port = "80"
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}