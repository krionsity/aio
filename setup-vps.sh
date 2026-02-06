#!/usr/bin/env bash
set -e

echo "=== VPS BASE SETUP (NO DOCKER) ==="

# 1. Update system
apt update -y
apt upgrade -y

# 2. Install base packages
apt install -y \
  curl wget git unzip zip \
  build-essential \
  screen tmux htop nano \
  ca-certificates software-properties-common

# 3. Install Python 3 + pip + venv
apt install -y python3 python3-pip python3-venv

# 4. Install Node.js LTS (NodeSource)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs

# 5. Upgrade pip
python3 -m pip install --upgrade pip

# 6. Alias setup
BASHRC="$HOME/.bashrc"

# alias py -> python3
if ! grep -q "alias py=" "$BASHRC"; then
  echo "alias py='python3'" >> "$BASHRC"
fi

# alias pip -> pip3
if ! grep -q "alias pip=" "$BASHRC"; then
  echo "alias pip='pip3'" >> "$BASHRC"
fi

# alias vak -> activate venv
if ! grep -q "alias vak=" "$BASHRC"; then
  echo "alias vak='source .venv/bin/activate'" >> "$BASHRC"
fi

# 7. Auto-create venv helper (optional)
if ! grep -q "mkvenv()" "$BASHRC"; then
cat << 'EOF' >> "$BASHRC"

mkvenv() {
  python3 -m venv .venv
  source .venv/bin/activate
  pip install --upgrade pip
}
EOF
fi

# 8. Reload bashrc
source "$BASHRC"

echo ""
echo "=== INSTALLATION COMPLETE ==="
echo "Python  : $(python3 --version)"
echo "Node    : $(node --version)"
echo "NPM     : $(npm --version)"
echo ""
echo "Aliases available:"
echo "  py    -> python3"
echo "  pip   -> pip3"
echo "  vak   -> activate .venv"
echo "  mkvenv-> create + activate venv"
