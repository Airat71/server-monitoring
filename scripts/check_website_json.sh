#!/bin/bash

################################################################################
# Script: check_website_json.sh
# Description: Проверка доступности сайта и создание JSON для дашборда
# Author: Airat
# Version: 1.0
################################################################################

WEBSITE="https://example.com"
JSON_FILE="/srv/projects/monitoring/dashboard/website_status.json"
TIMEOUT=10

# Создаём директорию если нет
mkdir -p /srv/projects/monitoring/dashboard

# Проверка доступности
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$WEBSITE" 2>/dev/null)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ] && [ "$HTTP_CODE" = "200" ]; then
    STATUS="UP"
    MESSAGE="Website is accessible"
else
    STATUS="DOWN"
    MESSAGE="Website is not accessible"
fi

# Создаём JSON
cat > "$JSON_FILE" <<JSON
{
  "timestamp": "$(date -Iseconds)",
  "website": "${WEBSITE}",
  "status": "${STATUS}",
  "http_code": "${HTTP_CODE}",
  "message": "${MESSAGE}"
}
JSON

echo "Website status: ${STATUS}"

