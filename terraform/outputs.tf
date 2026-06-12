output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "EC2 Public IP (if assigned)"
  value       = aws_instance.this.public_ip
}

output "ssm_connect_command" {
  description = "Connect to EC2 via SSM Session Manager (no SSH key needed)"
  value       = "aws ssm start-session --target ${aws_instance.this.id} --region ${var.aws_region}"
}

output "cloudwatch_dashboard_url" {
  description = "CloudWatch Dashboard URL"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.ec2.dashboard_name}"
}

output "log_group_messages" {
  value = aws_cloudwatch_log_group.system_messages.name
}

output "log_group_syslog" {
  value = aws_cloudwatch_log_group.system_syslog.name
}
