#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna create-client CLIENT_NAME"
    echo ""
    exit 1
fi

CLIENT_ROOT="/opt/myLuna/clients/$CLIENT"

echo ""
echo "Creating Hermes profile..."

hermes profile create "$CLIENT"

echo ""
echo "Creating myLuna structure..."

mkdir -p "$CLIENT_ROOT"

mkdir -p "$CLIENT_ROOT/memory/core"
mkdir -p "$CLIENT_ROOT/memory/style"
mkdir -p "$CLIENT_ROOT/memory/formats"
mkdir -p "$CLIENT_ROOT/memory/projects"
mkdir -p "$CLIENT_ROOT/memory/knowledge"
mkdir -p "$CLIENT_ROOT/memory/graph"
mkdir -p "$CLIENT_ROOT/memory/archive"
mkdir -p "$CLIENT_ROOT/memory/db"

mkdir -p "$CLIENT_ROOT/vault"
mkdir -p "$CLIENT_ROOT/vault/exports"

mkdir -p "$CLIENT_ROOT/prompts"
mkdir -p "$CLIENT_ROOT/knowledge"
mkdir -p "$CLIENT_ROOT/backups"
mkdir -p "$CLIENT_ROOT/logs"

mkdir -p "$CLIENT_ROOT/metadata"

cat > "$CLIENT_ROOT/metadata/client.yaml" << EOF
client_name: $CLIENT
status: active
hermes_profile: $CLIENT
created_at: $(date)
EOF

cat > "$CLIENT_ROOT/README.md" << EOF
# $CLIENT

Created by myLuna

Hermes Profile:
$CLIENT
EOF

echo ""
echo "Client created successfully:"
echo "$CLIENT"
echo ""
echo "Location:"
echo "$CLIENT_ROOT"