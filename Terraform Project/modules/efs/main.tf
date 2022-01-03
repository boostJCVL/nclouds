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
#Create EFS
resource "aws_efs_file_system" "efs" {
  tags = {
      Name = "carlos-tf-efs"
  }
}
#Mount the EFS
resource "aws_efs_mount_target" "mount" {
  count = length(var.subnets) #References the subnets variable in the variables.tf file in this module
  file_system_id = aws_efs_file_system.efs.id 
  subnet_id = var.subnets[count.index] #References the subnets variable in the variables.tf file in this module
  security_groups = var.security_group
}

#Create EFS Access Point
resource "aws_efs_access_point" "efs_ap" {
  file_system_id = aws_efs_file_system.efs.id
}

resource "aws_instance" "efs_load" {
  ami = data.aws_ami.amazon-linux-2.id 
  instance_type = "t2.micro"
  iam_instance_profile = "s3-efs-full-access"
  subnet_id = var.subnets[1]
  user_data = templatefile("./modules/efs/load_efs.tftpl", { efs_name = aws_efs_file_system.efs.dns_name})
  vpc_security_group_ids = var.security_group

  depends_on = [
    aws_efs_mount_target.mount 
  ]

  tags = {
      Name = "EFS Load"
  }
}