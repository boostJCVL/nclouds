data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}



resource "aws_launch_configuration" "carlos-tf-lc" {
  name_prefix   = "carlos-tf-lc"
  image_id      = data.aws_ami.amazon-2.id
  instance_type = "t2.micro"

  user_data = <<-EOF
    #!/bin/bash
    sudo yum install amazon-efs-utils -y
    sudo amazon-linux-extras install nginx1 -y
    sudo rm -rf /usr/share/nginx/html/*
    sudo mount -t efs -o tls,accesspoint=fsap-0e636c40dea4a1b62 fs-09aadb750f53b8d50://usr/share/nginx/html
EOF


  lifecycle {
    create_before_destroy = true
  }
}
