#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna secret-export CLIENT"
    echo ""
    exit 1
fi

CLIENT_ROOT="/opt/myLuna/clients/$CLIENT"
VAULT_FILE="$CLIENT_ROOT/vault/secrets.env"
EXPORT_DIR="$CLIENT_ROOT/vault/exports"
EXPORT_FILE="$EXPORT_DIR/hermes.env"

if [ ! -d "$CLIENT_ROOT" ]; then
    echo "Client not found: $CLIENT"
    exit 1
fi

if [ ! -f "$VAULT_FILE" ]; then
    echo "No secrets found for client: $CLIENT"
    echo "Add one first:"
    echo "myluna secret-add $CLIENT OPENROUTER_API_KEY"
    exit 1
fi

mkdir -p "$EXPORT_DIR"

cp "$VAULT_FILE" "$EXPORT_FILE"
chmod 600 "$EXPORT_FILE"

echo ""
echo "Exported Hermes env:"
echo "$EXPORT_FILE"
echo ""
echo "Do not share this file publicly."