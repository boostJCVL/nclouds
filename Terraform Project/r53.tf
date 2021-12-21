resource "aws_route53_zone" "carlos-nclouds-tf-test" {
  name = "carlos-nclouds-tf-test.com"
}

resource "aws_route53_record" "carlos-tf-r53" {
  zone_id = aws_route53_zone.carlos-nclouds-tf-test.id
  name = "www.carlos-tf.com"
  type = "CNAME"
  ttl = "300"
  records = ["carlos.training-nclouds.com"]
}