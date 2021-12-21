resource "aws_eip" "carlos-tf-eip" {
    tags = {
        Name = "carlos-tf-eip"
    }
}

resource "aws_lb" "carlos-tf-nlb" {
  name = "carlos-tf-nlb"
  load_balancer_type = "network"
  subnets = [aws_subnet.pub1.id, aws_subnet.pub2.id, aws_subnet.pub3.id]
}

resource "aws_lb_target_group" "carlos-tf-lb-tg" {
  name = "carlos-tf-lb-tg"
  port = 80
  protocol = "TCP"
  vpc_id = aws_vpc.carlos.id
}

resource "aws_lb_listener" "carlos-tf-nlb-listener" {
  load_balancer_arn = aws_lb.carlos-tf-nlb.arn
  port = 80
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.carlos-tf-lb-tg.arn
  }

}
