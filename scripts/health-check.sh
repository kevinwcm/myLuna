#!/bin/bash

LUNA_ROOT="/opt/myLuna"
CLIENTS_ROOT="$LUNA_ROOT/clients"

PASS=0
WARN=0
FAIL=0

pass() {
    echo "✅ PASS: $1"
    PASS=$((PASS+1))
}

warn() {
    echo "⚠️  WARN: $1"
    WARN=$((WARN+1))
}

fail() {
    echo "❌ FAIL: $1"
    FAIL=$((FAIL+1))
}

echo ""
echo "================================="
echo " myLuna Health Check"
echo "================================="
echo ""

# System checks

if command -v docker >/dev/null 2>&1; then
    pass "Docker installed"
else
    fail "Docker not installed"
fi

if docker ps >/dev/null 2>&1; then
    pass "Docker permission OK"
else
    warn "Docker installed but current user may not have permission"
fi

if command -v hermes >/dev/null 2>&1; then
    pass "Hermes installed"
else
    fail "Hermes not installed"
fi

if command -v myluna >/dev/null 2>&1; then
    pass "myluna command installed"
else
    fail "myluna command missing"
fi

# Folder checks

if [ -d "$LUNA_ROOT" ]; then
    pass "$LUNA_ROOT exists"
else
    fail "$LUNA_ROOT missing"
fi

if [ -d "$CLIENTS_ROOT" ]; then
    pass "Clients folder exists"
else
    fail "Clients folder missing"
fi

# Client checks

if [ -d "$CLIENTS_ROOT" ] && [ -n "$(ls -A "$CLIENTS_ROOT" 2>/dev/null)" ]; then
    CLIENT_COUNT=$(find "$CLIENTS_ROOT" -mindepth 1 -maxdepth 1 -type d | wc -l | xargs)
    pass "Client count: $CLIENT_COUNT"

    echo ""
    echo "Client Checks"
    echo "-------------"

    for CLIENT_PATH in "$CLIENTS_ROOT"/*; do

        [ -d "$CLIENT_PATH" ] || continue

        CLIENT=$(basename "$CLIENT_PATH")

        if [[ "$CLIENT" == *_before_restore_* ]]; then
            warn "Ignoring restore safety folder: $CLIENT"
            continue
        fi

        echo ""
        echo "Client: $CLIENT"

        if command -v "$CLIENT" >/dev/null 2>&1; then
        pass "Hermes wrapper exists for $CLIENT"
        else
        warn "Hermes wrapper missing for $CLIENT"
        fi

        if [ -f "$CLIENT_PATH/metadata/client.yaml" ]; then
            pass "$CLIENT metadata exists"
        else
            warn "$CLIENT metadata missing"
        fi

        if [ -f "$CLIENT_PATH/vault/vault.db" ]; then
            pass "$CLIENT vault.db exists"
        else
            warn "$CLIENT vault.db missing"
        fi

        if [ -f "$CLIENT_PATH/vault/vault.key" ]; then
            pass "$CLIENT vault.key exists"
        else
            warn "$CLIENT vault.key missing"
        fi

        if [ -f "$CLIENT_PATH/vault/exports/hermes.env" ]; then
            pass "$CLIENT hermes.env export exists"
        else
            warn "$CLIENT hermes.env export missing"
        fi

        if [ -f "$CLIENT_PATH/memory/db/memory_index.sqlite" ]; then
            pass "$CLIENT memory index exists"
        else
            warn "$CLIENT memory index missing"
        fi

        if [ -f "$CLIENT_PATH/memory/graph/relationships.csv" ]; then
            pass "$CLIENT relationships.csv exists"
        else
            warn "$CLIENT relationships.csv missing"
        fi

        if [ -f "$CLIENT_PATH/memory/graph/graph.db" ]; then
            pass "$CLIENT graph.db exists"
        else
            warn "$CLIENT graph.db missing"
        fi

        if [ -d "$CLIENT_PATH/backups" ]; then
            pass "$CLIENT local backup folder exists"
        else
            warn "$CLIENT local backup folder missing"
        fi

        GLOBAL_BACKUP_DIR="$LUNA_ROOT/backups/$CLIENT"

        if [ -d "$GLOBAL_BACKUP_DIR" ]; then
            LATEST_BACKUP=$(find "$GLOBAL_BACKUP_DIR" -type f -name "*.tar.gz" | sort | tail -n 1)

            if [ -n "$LATEST_BACKUP" ]; then
                pass "$CLIENT latest backup found: $(basename "$LATEST_BACKUP")"
            else
                warn "$CLIENT backup folder exists but no backup file found"
            fi
        else
            warn "$CLIENT global backup folder missing"
        fi
    done
else
    warn "No clients found"
fi

echo ""
echo "Summary"
echo "--------"
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
echo ""

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi