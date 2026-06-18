#!/bin/bash

CLIENT=$1
BACKUP_FILE=$2

if [ -z "$CLIENT" ] || [ -z "$BACKUP_FILE" ]; then
    echo ""
    echo "Usage:"
    echo "myluna restore CLIENT BACKUP_FILE"
    echo ""
    exit 1
fi

CLIENT_ROOT="/opt/myLuna/clients/$CLIENT"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found:"
    echo "$BACKUP_FILE"
    exit 1
fi

echo ""
echo "You are about to restore client:"
echo "$CLIENT"
echo ""
echo "From backup:"
echo "$BACKUP_FILE"
echo ""

read -p "Type RESTORE to continue: " CONFIRM

if [ "$CONFIRM" != "RESTORE" ]; then
    echo "Cancelled."
    exit 1
fi

if [ -d "$CLIENT_ROOT" ]; then
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    mv "$CLIENT_ROOT" "${CLIENT_ROOT}_before_restore_$TIMESTAMP"
fi

tar -xzf "$BACKUP_FILE" -C "/opt/myLuna/clients"

echo ""
echo "Restore completed:"
echo "$CLIENT"
echo ""