#!/bin/bash

set -e

LUNA_ROOT="/opt/myLuna"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================="
echo "myLuna Phase 1 Installer"
echo "================================="

if [ "$(id -u)" -eq 0 ]; then
    echo "Please run as normal user, not root."
    echo "Use: ./install.sh"
    exit 1
fi

echo ""
echo "Installing dependencies..."

sudo apt update
sudo apt install -y \
curl \
git \
sqlite3 \
python3 \
python3-pip \
python3-venv \
docker.io

echo ""
echo "Creating myLuna structure..."

sudo mkdir -p "$LUNA_ROOT"/clients
sudo mkdir -p "$LUNA_ROOT"/shared/scripts
sudo mkdir -p "$LUNA_ROOT"/shared/templates
sudo mkdir -p "$LUNA_ROOT"/shared/docs
sudo mkdir -p "$LUNA_ROOT"/shared/backups
sudo mkdir -p "$LUNA_ROOT"/runtime/hermes
sudo mkdir -p "$LUNA_ROOT"/dashboard
sudo mkdir -p "$LUNA_ROOT"/logs

sudo chown -R "$USER:$USER" "$LUNA_ROOT"

echo ""
echo "Copying myLuna files..."

cp -r "$CURRENT_DIR/scripts/"* "$LUNA_ROOT/shared/scripts/" 2>/dev/null || true
cp -r "$CURRENT_DIR/templates/"* "$LUNA_ROOT/shared/templates/" 2>/dev/null || true
cp -r "$CURRENT_DIR/docs/"* "$LUNA_ROOT/shared/docs/" 2>/dev/null || true
cp -r "$CURRENT_DIR/dashboard/"* "$LUNA_ROOT/dashboard/" 2>/dev/null || true
sudo mkdir -p "$LUNA_ROOT/shared/hermes-skills"
cp -r "$CURRENT_DIR/hermes-skills/"* "$LUNA_ROOT/shared/hermes-skills/" 2>/dev/null || true

chmod +x "$LUNA_ROOT/shared/scripts/"* 2>/dev/null || true

echo ""
echo "Installing myluna command..."

sudo ln -sf "$LUNA_ROOT/shared/scripts/myluna" /usr/local/bin/myluna

echo ""
echo "Checking Docker..."

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"

echo ""
echo "Checking Hermes..."

if command -v hermes >/dev/null 2>&1
then
    echo "Hermes already installed."
else
    echo "Installing Hermes..."
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
fi

echo ""
echo "Installation Complete"
echo ""
echo "Next Steps:"
echo "1. Log out and log back in"
echo "2. Run: myluna health-check"
echo ""
echo "Installing Python vault dependency..."

python3 -m pip install --user cryptography --break-system-packages || true

echo ""
echo "Installing Python vector dependencies..."

python3 -m pip install --user sentence-transformers numpy --break-system-packages || true

echo ""
echo "Installing Python dashboard dependencies..."

python3 -m pip install --user fastapi uvicorn jinja2 --break-system-packages || true