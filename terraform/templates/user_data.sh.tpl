#!/bin/bash
set -e

# ── Step 1: Install CloudWatch Agent ─────────────────────────
yum install amazon-cloudwatch-agent -y

# ── Step 2: Write config file ─────────────────────────────────
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
cat <<'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
${cw_config}
EOF

# ── Step 3: Apply config & start agent ───────────────────────
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# ── Step 4: Enable on reboot ──────────────────────────────────
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent
