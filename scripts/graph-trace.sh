#!/bin/bash

CLIENT=$1
ENTITY=$2

if [ -z "$CLIENT" ] || [ -z "$ENTITY" ]; then
    echo ""
    echo "Usage:"
    echo "myluna graph-trace CLIENT ENTITY"
    echo ""
    exit 1
fi

python3 /opt/myLuna/shared/scripts/graph/graph_tool.py trace "$CLIENT" "$ENTITY"