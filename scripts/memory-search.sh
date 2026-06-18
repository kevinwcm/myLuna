#!/bin/bash

CLIENT=$1
QUERY=$2

if [ -z "$CLIENT" ] || [ -z "$QUERY" ]; then
    echo ""
    echo "Usage:"
    echo "myluna memory-search CLIENT QUERY"
    echo ""
    exit 1
fi

python3 /opt/myLuna/shared/scripts/memory/memory_tool.py search "$CLIENT" "$QUERY"