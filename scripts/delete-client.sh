#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna delete-client CLIENT_NAME"
    echo ""
    exit 1
fi

CLIENT_ROOT="/opt/myLuna/clients/$CLIENT"

if [ ! -d "$CLIENT_ROOT" ]; then
    echo "Client not found: $CLIENT"
    exit 1
fi

echo ""
echo "You are about to delete myLuna client:"
echo "$CLIENT"
echo ""
echo "This removes:"
echo "$CLIENT_ROOT"
echo ""
echo "Hermes profile deletion is NOT automated in Phase 1."
echo "You may delete the Hermes profile manually later if needed."
echo ""

read -p "Type DELETE to continue: " CONFIRM

if [ "$CONFIRM" != "DELETE" ]; then
    echo "Cancelled."
    exit 1
fi

rm -rf "$CLIENT_ROOT"

echo ""
echo "Client folder deleted:"
echo "$CLIENT"
echo ""