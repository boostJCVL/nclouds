output "elb" {
    value = aws_lb.nlb.id
}

output "elb_dns_name" {
    value = aws_lb.nlb.dns_name
}

output "target_group_arn" {
    value = aws_lb_target_group.tg.arn 
}