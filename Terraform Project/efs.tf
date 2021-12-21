resource "aws_efs_file_system" "carlos-tf-efs" {
    creation_token = "carlos-tf-efs"
    encrypted = true
    tags = {
        Name = "carlos-tf-efs"
    }
    lifecycle_policy {
      transition_to_ia = "AFTER_30_DAYS"
    }
}

resource "aws_efs_access_point" "carlos-tf-efs-ap" {
  file_system_id = aws_efs_file_system.carlos-tf-efs.id
}