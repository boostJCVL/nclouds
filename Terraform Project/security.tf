resource "aws_security_group" "carlos-tf-pub-sg" {
    name = "carlos-tf-pub-sg"
    description = "public internet access"
    vpc_id = aws_vpc.carlos.id
    tags = {
        Name = "carlos-tf-pub-sg"
    }
}

resource "aws_security_group_rule" "public_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.carlos-tf-pub-sg.id
}

resource "aws_security_group_rule" "public_in_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.carlos-tf-pub-sg.id
}

resource "aws_security_group_rule" "public_in_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.carlos-tf-pub-sg.id
}

resource "aws_security_group_rule" "public_in_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.carlos-tf-pub-sg.id
}

resource "tls_private_key" "carlos-tf-web-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "carlos-tf-instance-key" {
  key_name = "carlos-tf-web-key"
  public_key = tls_private_key.carlos-tf-web-key.public_key_openssh
  
}

resource "local_file" "carlos-tf-web-key" {
  content = tls_private_key.carlos-tf-web-key.private_key_pem
  filename = "carlos-tf-web-key"
}