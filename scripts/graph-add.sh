#!/bin/bash

CLIENT=$1
SOURCE=$2
TYPE=$3
TARGET=$4

if [ -z "$CLIENT" ] || [ -z "$SOURCE" ] || [ -z "$TYPE" ] || [ -z "$TARGET" ]; then
    echo ""
    echo "Usage:"
    echo "myluna graph-add CLIENT SOURCE TYPE TARGET"
    echo ""
    exit 1
fi

python3 /opt/myLuna/shared/scripts/graph/graph_tool.py add "$CLIENT" "$SOURCE" "$TYPE" "$TARGET"