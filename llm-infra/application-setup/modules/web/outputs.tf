output "web_instance_id" {
  value = aws_instance.web.id
}

output "web_public_ip" {
  value = aws_eip.web.public_ip
}

output "web_security_group_id" {
  value = aws_security_group.web.id
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}