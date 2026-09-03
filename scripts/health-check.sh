#!/usr/bin/env bash

set -euo pipefail


ENVIRONMENT="${1:-}"
PORT="${2:-}"


if [[ -z "$ENVIRONMENT" || -z "$PORT" ]]; then

    echo "Usage:"
    echo "./health-check.sh blue 8081"
    echo "./health-check.sh green 8082"

    exit 1

fi


echo "🔍 Checking ${ENVIRONMENT} health on port ${PORT}"


# Health endpoint

if curl -sf "http://localhost:${PORT}/health" > /dev/null; then


    echo "✅ Health endpoint OK"


else

    echo "❌ Health endpoint failed"

    exit 1

fi



# Instance verification

INSTANCE=$(curl -s "http://localhost:${PORT}/api/instance")


echo "📌 Instance information:"
echo "$INSTANCE"



echo ""

echo "✅ ${ENVIRONMENT} deployment verified successfully"


exit 0