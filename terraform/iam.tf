# ── IAM Role for EC2 ─────────────────────────────────────────
resource "aws_iam_role" "ec2_cloudwatch" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

# Attach CloudWatchAgentServerPolicy (required by the lab)
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Allow SSM so you can connect without a bastion/SSH key
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_cloudwatch" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_cloudwatch.name
}
