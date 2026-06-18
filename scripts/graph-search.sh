#!/bin/bash

CLIENT=$1
ENTITY=$2

if [ -z "$CLIENT" ] || [ -z "$ENTITY" ]; then
    echo ""
    echo "Usage:"
    echo "myluna graph-search CLIENT ENTITY"
    echo ""
    exit 1
fi

python3 /opt/myLuna/shared/scripts/graph/graph_tool.py search "$CLIENT" "$ENTITY"