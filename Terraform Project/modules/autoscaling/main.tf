data "aws_ami" "amazon-linux-2" {
    most_recent = true

    filter {
      name = "owner-alias"
      values = ["amazon"]
    }
    
    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
    owners = ["amazon"]
}

resource "aws_security_group" "sg" {
  vpc_id = var.vpc

  ingress {
      from_port = 80
      to_port = 80
      protocol = "TCP"
      description = "HTTP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      description = "SSH"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 2049
      to_port = 2049
      protocol = "TCP"
      description = "NFS"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
      Name = "carlos-tf-sg"
  }
}

resource "aws_launch_configuration" "asg_conf" {
  name_prefix = "carlos-tf-"
  image_id = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  iam_instance_profile = "efs-full-access"
  user_data = templatefile("./modules/autoscaling/nginx_efs.tftpl", {efs_name = var.efs_dns})
  security_groups = [aws_security_group.sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "carlos-tf-asg"
  launch_configuration = aws_launch_configuration.asg_conf.name 
  min_size = var.min 
  max_size = var.max 
  desired_capacity = var.desired 
  vpc_zone_identifier = var.subnets 

  lifecycle {
    create_before_destroy = true
    ignore_changes = [load_balancers, target_group_arns]
  }
} 

resource "aws_autoscaling_attachment" "asg_tg" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  alb_target_group_arn = var.target_group
}