# ── EC2 Instance ──────────────────────────────────────────────
resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  iam_instance_profile   = aws_iam_instance_profile.ec2_cloudwatch.name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  # user_data runs on first boot — installs & starts CloudWatch Agent automatically
  user_data = base64encode(local.user_data_script)

  metadata_options {
    http_tokens = "required" # IMDSv2
  }

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.tags, { Name = "${var.project_name}-ec2" })
}
