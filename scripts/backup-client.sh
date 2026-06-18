#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna backup CLIENT"
    echo ""
    exit 1
fi

CLIENT_ROOT="/opt/myLuna/clients/$CLIENT"

if [ ! -d "$CLIENT_ROOT" ]; then
    echo "Client not found: $CLIENT"
    exit 1
fi

BACKUP_ROOT="/opt/myLuna/backups/$CLIENT"

mkdir -p "$BACKUP_ROOT"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="$BACKUP_ROOT/${CLIENT}_${TIMESTAMP}.tar.gz"

echo ""
echo "Creating backup..."
echo ""

tar -czf "$BACKUP_FILE" -C "/opt/myLuna/clients" "$CLIENT"

echo ""
echo "Backup completed:"
echo "$BACKUP_FILE"
echo ""