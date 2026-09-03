#!/usr/bin/env bash

set -euo pipefail


APP_NAME="spring-boot-app"
APP_DIR="/opt/spring-boot-app"

JAVA_OPTS="-Xms512m -Xmx1024m"
SPRING_PROFILE="prod"


ENVIRONMENT="${1:-}"
NEW_JAR_PATH="${2:-}"


if [[ -z "$ENVIRONMENT" || -z "$NEW_JAR_PATH" ]]; then

    echo "Usage:"
    echo "./deploy.sh blue <jar-path>"
    echo "./deploy.sh green <jar-path>"

    exit 1

fi



case "$ENVIRONMENT" in


    blue)

        PORT=8081
        INSTANCE_NAME="BLUE"

        ;;


    green)

        PORT=8082
        INSTANCE_NAME="GREEN"

        ;;


    *)

        echo "Environment must be blue or green"

        exit 1

        ;;

esac



INSTANCE_DIR="${APP_DIR}/${INSTANCE_NAME}"

JAR_NAME="${APP_NAME}-${INSTANCE_NAME}.jar"

PID_FILE="${INSTANCE_DIR}/app.pid"

LOG_FILE="${INSTANCE_DIR}/app.log"



echo "================================="
echo "🚀 Deploying ${APP_NAME}"
echo "🌎 Instance: ${INSTANCE_NAME}"
echo "🔌 Port: ${PORT}"
echo "📦 Artifact: ${NEW_JAR_PATH}"
echo "================================="



mkdir -p "$INSTANCE_DIR"
mkdir -p "${APP_DIR}/versions"



# Detener instancia anterior

if [[ -f "$PID_FILE" ]]; then


    PID=$(cat "$PID_FILE")


    if kill -0 "$PID" 2>/dev/null; then

        echo "🛑 Stopping ${INSTANCE_NAME} PID=${PID}"

        kill "$PID"

        sleep 5


    fi


fi



# Backup

if [[ -f "${INSTANCE_DIR}/${JAR_NAME}" ]]; then


    TIMESTAMP=$(date +%Y%m%d%H%M%S)

    echo "📦 Creating backup"


    cp "${INSTANCE_DIR}/${JAR_NAME}" \
    "${APP_DIR}/versions/${JAR_NAME}-${TIMESTAMP}"

fi



# Instalar nueva versión

echo "📦 Installing artifact"


cp "$NEW_JAR_PATH" "${INSTANCE_DIR}/${JAR_NAME}"

chmod 755 "${INSTANCE_DIR}/${JAR_NAME}"



# Ejecutar aplicación

echo "▶️ Starting ${INSTANCE_NAME}"



INSTANCE_NAME=$INSTANCE_NAME nohup java $JAVA_OPTS \
    -jar "${INSTANCE_DIR}/${JAR_NAME}" \
    --spring.profiles.active="$SPRING_PROFILE" \
    --server.port="$PORT" \
    > "$LOG_FILE" 2>&1 &



NEW_PID=$!


echo "$NEW_PID" > "$PID_FILE"



echo "PID: $NEW_PID"



# Health Check

echo "🔍 Checking health"



for i in {1..20}; do


    if curl -sf "http://localhost:${PORT}/health" > /dev/null; then


        echo "✅ ${INSTANCE_NAME} is healthy"


        curl -s "http://localhost:${PORT}/api/instance"


        echo ""

        exit 0


    fi


    sleep 3


done



echo "❌ Deployment failed"

exit 1