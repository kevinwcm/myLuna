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

python3 /opt/myLuna/shared/scripts/vault/vault_tool.py add "$CLIENT" "$KEY_NAME"