output "autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}

output "launch_template_id" {
  value = aws_launch_template.asg_launch_template.id
}

output "security_group_id" {
  value       = aws_security_group.asg_sg.id
  description = "The security group ID for the ASG"
}


output "iam_instance_profile" {
  value       = aws_iam_instance_profile.instance_profile.name
  description = "The IAM instance profile for the ASG instances"
}
