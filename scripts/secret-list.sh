#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna secret-list CLIENT"
    echo ""
    exit 1
fi

VAULT_FILE="/opt/myLuna/clients/$CLIENT/vault/secrets.env"

if [ ! -f "$VAULT_FILE" ]; then
    echo "No secrets found for client: $CLIENT"
    exit 0
fi

echo ""
echo "Secrets for client: $CLIENT"
echo "=========================="
echo ""

cut -d '=' -f 1 "$VAULT_FILE"

echo ""
echo "Values are hidden."