#!/bin/bash
# Network allowlist for the job-agent dev container.
# Default-deny outbound; explicit ALLOW for what Claude Code and
# the framework legitimately need.
#
# Adapted from Anthropic's reference init-firewall.sh.

set -euo pipefail
IFS=$'\n\t'

echo "[firewall] flushing existing rules"
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X

# Default deny outbound; allow loopback and established connections
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# DNS (needed to resolve the allowlist)
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Allowlist domains. Resolve to IPs at firewall init time.
ALLOWED_DOMAINS=(
  # Claude API + auth
  "api.anthropic.com"
  "claude.ai"
  "console.anthropic.com"
  "statsig.anthropic.com"
  # GitHub (git, gh, releases, raw)
  "github.com"
  "api.github.com"
  "codeload.github.com"
  "objects.githubusercontent.com"
  "raw.githubusercontent.com"
  # Package registries
  "registry.npmjs.org"
  "pypi.org"
  "files.pythonhosted.org"
  # Container/dev tooling occasionally needed
  "ghcr.io"
)

for domain in "${ALLOWED_DOMAINS[@]}"; do
  echo "[firewall] resolving $domain"
  ips=$(dig +short A "$domain" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || true)
  if [ -z "$ips" ]; then
    echo "[firewall] WARNING: could not resolve $domain"
    continue
  fi
  for ip in $ips; do
    sudo iptables -A OUTPUT -d "$ip" -j ACCEPT
  done
done

# Verify we can still reach the API
echo "[firewall] verifying api.anthropic.com is reachable"
if curl -s --max-time 5 -o /dev/null -w "%{http_code}" https://api.anthropic.com | grep -qE '^[2-4][0-9][0-9]$'; then
  echo "[firewall] OK"
else
  echo "[firewall] WARNING: api.anthropic.com not reachable. Check rules."
fi

echo "[firewall] done"
