#!/bin/bash

CLIENT=$1
shift

QUERY="$*"

if [ -z "$CLIENT" ] || [ -z "$QUERY" ]; then
    echo ""
    echo "Usage:"
    echo "myluna semantic-search CLIENT QUERY"
    echo ""
    exit 1
fi

python3 /opt/myLuna/shared/scripts/vector/vector_tool.py search "$CLIENT" "$QUERY"