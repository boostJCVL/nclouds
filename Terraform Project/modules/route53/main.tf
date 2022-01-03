resource "aws_route53_record" "www" {
  zone_id = "Z03828583ADZCNSDCLLWY"
  name = "carlos-tf-nclouds.com"
  type = "CNAME"
  ttl = "300"
  records = [var.elb_dns_name]
}