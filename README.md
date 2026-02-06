## Quick install examples

Run as root (preferred on fresh VPS):
```bash
curl -fsSL https://raw.githubusercontent.com/krionsity/aio/main/setup-vps.sh -o setup-vps.sh
chmod +x setup-vps.sh
sudo ./setup-vps.sh
```

Run and inspect first:
```bash
curl -fsSL https://raw.githubusercontent.com/krionsity/aio/main/setup-vps.sh -o setup-vps.sh
less setup-vps.sh
# if good:
sudo bash setup-vps.sh
```

Original one-liner (not recommended without inspection):
```bash
curl -fsSL https://raw.githubusercontent.com/krionsity/aio/main/setup-vps.sh | bash
```

## Verify installation

After the script finishes, run:
```bash
python3 --version
node --version
npm --version

# check aliases / function
grep "alias py=" ~/.bashrc || true
grep "mkvenv()" ~/.bashrc || true
```

To use the venv helper:
```bash
# create + activate venv in the current directory
mkvenv

# or manually
python3 -m venv .venv
source .venv/bin/activate
```

## Customization tips

- To avoid modifying root's .bashrc, run the installer as your regular user and use a root shell for apt, or manually add the alias lines to your user .bashrc.
- If you want to skip Node.js installation, edit the script to comment out the NodeSource lines before running.
- To add other packages, append them to the apt install list in the script.
