#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo ""
    echo "Usage:"
    echo "myluna memory-init CLIENT"
    echo ""
    exit 1
fi

CLIENT_ROOT="/opt/myLuna/clients/$CLIENT"
MEMORY_ROOT="$CLIENT_ROOT/memory"

if [ ! -d "$CLIENT_ROOT" ]; then
    echo "Client not found: $CLIENT"
    exit 1
fi

mkdir -p "$MEMORY_ROOT/core"
mkdir -p "$MEMORY_ROOT/style"
mkdir -p "$MEMORY_ROOT/formats"
mkdir -p "$MEMORY_ROOT/projects"
mkdir -p "$MEMORY_ROOT/knowledge"
mkdir -p "$MEMORY_ROOT/graph"
mkdir -p "$MEMORY_ROOT/archive"
mkdir -p "$MEMORY_ROOT/db"

touch "$MEMORY_ROOT/core/profile.md"
touch "$MEMORY_ROOT/style/writing_style.md"
touch "$MEMORY_ROOT/formats/email.md"
touch "$MEMORY_ROOT/formats/whatsapp.md"
touch "$MEMORY_ROOT/graph/relationships.md"

echo ""
echo "Memory initialized for client: $CLIENT"
echo "Location: $MEMORY_ROOT"
echo ""