#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna secret-export CLIENT"
    echo ""
    exit 1
fi

python3 /opt/myLuna/shared/scripts/vault/vault_tool.py export "$CLIENT"