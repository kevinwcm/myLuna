#!/bin/bash

CLIENT=$1
KEY_NAME=$2

if [ -z "$CLIENT" ] || [ -z "$KEY_NAME" ]; then
    echo ""
    echo "Usage:"
    echo "myluna secret-add CLIENT KEY_NAME"
    echo ""
    exit 1
fi

CLIENT_ROOT="/opt/myLuna/clients/$CLIENT"
VAULT_DIR="$CLIENT_ROOT/vault"
VAULT_FILE="$VAULT_DIR/secrets.env"

if [ ! -d "$CLIENT_ROOT" ]; then
    echo "Client not found: $CLIENT"
    exit 1
fi

mkdir -p "$VAULT_DIR"

echo ""
read -s -p "Enter value for $KEY_NAME: " SECRET_VALUE
echo ""

if [ -z "$SECRET_VALUE" ]; then
    echo "Secret value cannot be empty."
    exit 1
fi

touch "$VAULT_FILE"
chmod 600 "$VAULT_FILE"

# Remove existing key if it exists
grep -v "^$KEY_NAME=" "$VAULT_FILE" > "$VAULT_FILE.tmp" || true
mv "$VAULT_FILE.tmp" "$VAULT_FILE"

# Add new key
echo "$KEY_NAME=$SECRET_VALUE" >> "$VAULT_FILE"
chmod 600 "$VAULT_FILE"

echo ""
echo "Secret saved for client: $CLIENT"
echo "Key: $KEY_NAME"
echo "Value was not printed."