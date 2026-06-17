#!/bin/bash

set -e

LUNA_ROOT="/opt/myLuna"

echo "================================="
echo "myLuna Phase 1 Installer"
echo "================================="

echo ""
echo "Checking Ubuntu..."

if [ "$(id -u)" -eq 0 ]; then
    echo "Please run as normal user."
    echo "Use:"
    echo "./install.sh"
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
docker.io

echo ""
echo "Creating myLuna structure..."

sudo mkdir -p $LUNA_ROOT

sudo mkdir -p $LUNA_ROOT/clients

sudo mkdir -p $LUNA_ROOT/shared/scripts
sudo mkdir -p $LUNA_ROOT/shared/templates
sudo mkdir -p $LUNA_ROOT/shared/docs
sudo mkdir -p $LUNA_ROOT/shared/backups

sudo mkdir -p $LUNA_ROOT/runtime/hermes

sudo mkdir -p $LUNA_ROOT/dashboard

sudo mkdir -p $LUNA_ROOT/logs

sudo chown -R $USER:$USER $LUNA_ROOT

echo ""
echo "Checking Docker..."

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

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