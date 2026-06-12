#!/bin/bash
# Apply CloudWatch Agent config directly (skip the wizard)
# Use this if you want to use cloudwatch-agent-config.json instead

CONFIG_FILE="$(pwd)/cloudwatch-agent-config.json"

echo "Applying config from: $CONFIG_FILE"

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c "file:$CONFIG_FILE"

echo ""
echo "Checking status..."
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -m ec2 -a status
