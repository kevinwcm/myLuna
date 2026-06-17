#!/bin/bash

PASS=0
FAIL=0

echo ""
echo "================================="
echo " myLuna Health Check"
echo "================================="
echo ""

check_pass() {
    echo "✅ PASS: $1"
    PASS=$((PASS+1))
}

check_fail() {
    echo "❌ FAIL: $1"
    FAIL=$((FAIL+1))
}

# Docker

if command -v docker >/dev/null 2>&1; then
    check_pass "Docker installed"
else
    check_fail "Docker not installed"
fi

# Hermes

if command -v hermes >/dev/null 2>&1; then
    check_pass "Hermes installed"
else
    check_fail "Hermes not installed"
fi

# myLuna Root

if [ -d "/opt/myLuna" ]; then
    check_pass "/opt/myLuna exists"
else
    check_fail "/opt/myLuna missing"
fi

# Clients

if [ -d "/opt/myLuna/clients" ]; then
    check_pass "Clients folder exists"
else
    check_fail "Clients folder missing"
fi

echo ""
echo "Summary"
echo "--------"
echo "PASS: $PASS"
echo "FAIL: $FAIL"
echo ""

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi