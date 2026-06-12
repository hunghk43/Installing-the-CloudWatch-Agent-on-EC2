#!/bin/bash
# ============================================================
# Install & Configure CloudWatch Agent on EC2
# Session 02 - Mastering AWS System Monitoring
# Prerequisites: EC2 IAM Role must have CloudWatchAgentServerPolicy attached
# ============================================================

set -e

# ── Detect OS ────────────────────────────────────────────────
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS. Exiting."
    exit 1
fi

echo "Detected OS: $OS"

# ── Step 1: Install the Agent Package ────────────────────────
echo ""
echo "==> [1/4] Installing amazon-cloudwatch-agent..."

if [[ "$OS" == "amzn" || "$OS" == "rhel" || "$OS" == "centos" ]]; then
    sudo yum install amazon-cloudwatch-agent -y
elif [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt-get update -y
    sudo apt-get install amazon-cloudwatch-agent -y
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo "CloudWatch Agent installed successfully."

# ── Step 2: Run Configuration Wizard ─────────────────────────
echo ""
echo "==> [2/4] Running configuration wizard..."
echo "NOTE: You can also use the config file below (cloudwatch-agent-config.json)"
echo "      To skip the wizard and use the config file directly, press Ctrl+C now."
echo ""
sleep 3

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

# ── Step 3: Start the Agent ───────────────────────────────────
echo ""
echo "==> [3/4] Enabling and starting amazon-cloudwatch-agent..."

sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent

echo "CloudWatch Agent started."

# ── Step 4: Verify & Check Status ────────────────────────────
echo ""
echo "==> [4/4] Verifying agent status..."

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -m ec2 -a status

echo ""
echo "Done! CloudWatch Agent is running on this EC2 instance."
