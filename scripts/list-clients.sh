#!/bin/bash

CLIENTS_ROOT="/opt/myLuna/clients"

echo ""
echo "myLuna Clients"
echo "=============="
echo ""

if [ ! -d "$CLIENTS_ROOT" ]; then
    echo "No clients folder found."
    exit 0
fi

if [ -z "$(ls -A "$CLIENTS_ROOT" 2>/dev/null)" ]; then
    echo "No clients created yet."
    exit 0
fi

for client in "$CLIENTS_ROOT"/*; do
    if [ -d "$client" ]; then
        basename "$client"
    fi
done

echo ""