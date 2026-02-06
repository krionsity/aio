#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root (or use sudo)."
  exit 1
fi

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  case "${ID:-}" in
    ubuntu|debian) ;;
    *) case "${ID_LIKE:-}" in
         *debian*) ;;
         *) echo "Unsupported OS (Ubuntu/Debian only)."; exit 1 ;;
       esac ;;
  esac
else
  echo "Cannot detect OS."
  exit 1
fi

apt-get update -y
apt-get upgrade -y

apt-get install -y --no-install-recommends \
  ca-certificates curl wget git unzip zip \
  build-essential software-properties-common \
  screen tmux htop nano \
  openssl jq lsof net-tools \
  python3 python3-pip python3-venv

curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

python3 -m pip install --upgrade pip

cat > /etc/profile.d/vps-aio.sh <<'EOF'
alias py='python3'
alias pip='pip3'

vak() {
  if [ -f ".venv/bin/activate" ]; then
    . ".venv/bin/activate"
  else
    echo "No .venv in $(pwd)"
    return 1
  fi
}

mkvenv() {
  python3 -m venv .venv
  . ".venv/bin/activate"
  pip install --upgrade pip
}
EOF

chmod 0644 /etc/profile.d/vps-aio.sh

if [[ -f /root/.bashrc ]]; then
  if ! grep -q "^if \[ -f /etc/profile \]; then \. /etc/profile; fi$" /root/.bashrc 2>/dev/null; then
    printf "\nif [ -f /etc/profile ]; then . /etc/profile; fi\n" >> /root/.bashrc
  fi
fi

echo "Python: $(python3 --version)"
echo "Node: $(node -v)"
echo "NPM: $(npm --version)"
