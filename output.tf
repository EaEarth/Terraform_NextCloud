output "app_public_ip" {
  value = aws_eip.app.public_ip
}