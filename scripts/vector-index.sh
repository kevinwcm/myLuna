#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna vector-index CLIENT"
    echo ""
    exit 1
fi

python3 /opt/myLuna/shared/scripts/vector/vector_tool.py index "$CLIENT"