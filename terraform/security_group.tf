# ── Security Group ────────────────────────────────────────────
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-sg"
  description = "Allow outbound traffic for CloudWatch Agent"
  vpc_id      = data.aws_vpc.default.id

  # No inbound needed — using SSM Session Manager to connect
  egress {
    description = "Allow all outbound (CloudWatch, SSM endpoints)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.project_name}-sg" })
}
