output "load_balancer_arn" {
  value = aws_lb.public_lb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}



output "security_group_id" {
  value       = aws_security_group.lb_sg.id
  description = "The security group ID for the Load Balancer"
}
