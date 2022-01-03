output "efs_dns" {
    value = aws_efs_file_system.efs.dns_name
    depends_on = [aws_efs_mount_target.mount]
}