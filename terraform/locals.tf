locals {
  # Build user_data without templatefile to avoid Terraform escaping ${aws:...} inside JSON
  user_data_script = <<-SCRIPT
#!/bin/bash
set -e

# Step 1: Install CloudWatch Agent
yum install amazon-cloudwatch-agent -y

# Step 2: Write config — use single-quoted heredoc so shell won't expand ${aws:...}
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
cat <<'CWCONFIG' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
${replace(file("${path.module}/templates/cloudwatch-agent-config.json"), "$$", "$")}
CWCONFIG

# Step 3: Apply config & start agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Step 4: Enable on reboot
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent
SCRIPT
}
