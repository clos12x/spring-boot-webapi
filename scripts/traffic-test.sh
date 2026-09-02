#!/usr/bin/env bash

set -euo pipefail


URL="${1:-http://localhost}"

REQUESTS="${2:-10}"


echo "================================="
echo "🚦 Starting traffic test"
echo "🌐 URL: ${URL}"
echo "🔢 Requests: ${REQUESTS}"
echo "================================="

echo ""


for i in $(seq 1 "$REQUESTS")

do

    echo "Request ${i}"

    curl -s "${URL}/api/instance"

    echo ""

    echo "----------------------------"

done



echo ""

echo "✅ Traffic test completed"