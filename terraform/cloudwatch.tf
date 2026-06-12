# ── CloudWatch Log Groups ─────────────────────────────────────
resource "aws_cloudwatch_log_group" "system_messages" {
  name              = "/ec2/system/messages"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "system_syslog" {
  name              = "/ec2/system/syslog"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

# ── CloudWatch Dashboard ──────────────────────────────────────
resource "aws_cloudwatch_dashboard" "ec2" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "CPU Usage"
          region  = var.aws_region
          view    = "timeSeries"
          stacked = false
          period  = 60
          stat    = "Average"
          metrics = [
            ["CWAgent", "cpu_usage_user",   "InstanceId", aws_instance.this.id],
            ["CWAgent", "cpu_usage_system", "InstanceId", aws_instance.this.id],
            ["CWAgent", "cpu_usage_iowait", "InstanceId", aws_instance.this.id]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "Memory Used %"
          region  = var.aws_region
          view    = "timeSeries"
          stacked = false
          period  = 60
          stat    = "Average"
          metrics = [
            ["CWAgent", "mem_used_percent", "InstanceId", aws_instance.this.id]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "Disk Used %"
          region  = var.aws_region
          view    = "timeSeries"
          stacked = false
          period  = 60
          stat    = "Average"
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", aws_instance.this.id, "path", "/", "device", "xvda1", "fstype", "xfs"]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "Network Bytes"
          region  = var.aws_region
          view    = "timeSeries"
          stacked = false
          period  = 60
          stat    = "Sum"
          metrics = [
            ["CWAgent", "net_bytes_sent", "InstanceId", aws_instance.this.id, "interface", "eth0"],
            ["CWAgent", "net_bytes_recv", "InstanceId", aws_instance.this.id, "interface", "eth0"]
          ]
        }
      }
    ]
  })
}

# ── CloudWatch Alarm: High CPU ────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "cpu_usage_user"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU usage exceeded 80%"

  dimensions = {
    InstanceId = aws_instance.this.id
  }

  tags = var.tags
}
