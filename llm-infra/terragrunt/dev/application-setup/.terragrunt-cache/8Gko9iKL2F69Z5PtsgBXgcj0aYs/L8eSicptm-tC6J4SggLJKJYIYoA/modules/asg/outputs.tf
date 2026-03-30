output "asg_id" {
  value = aws_autoscaling_group.this.id
}

output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "asg_security_group_id" {
  value = aws_security_group.asg.id
}

output "launch_template_id" {
  value = aws_launch_template.this.id
}