#!/bin/bash

set -e

HOSTED_ZONE_ID="Z123456ABCDEFG"
RECORD_NAME="app.mayvue.com."
BLUE_IP="blue.mayvue.com"
GREEN_IP="green.mayvue.com"

echo "Starting Blue-Green Deployment switch..."

# Function to switch traffic
switch_traffic() {
  local BLUE_WEIGHT=$1
  local GREEN_WEIGHT=$2
  echo "Switching traffic: blue -> $BLUE_WEIGHT, green -> $GREEN_WEIGHT"

  aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch "{
    \"Changes\": [
      {
        \"Action\": \"UPSERT\",
        \"ResourceRecordSet\": {
          \"Name\": \"$RECORD_NAME\",
          \"Type\": \"CNAME\",
          \"SetIdentifier\": \"blue\",
          \"Weight\": $BLUE_WEIGHT,
          \"TTL\": 60,
          \"ResourceRecords\": [ { \"Value\": \"$BLUE_IP\" } ]
        }
      },
      {
        \"Action\": \"UPSERT\",
        \"ResourceRecordSet\": {
          \"Name\": \"$RECORD_NAME\",
          \"Type\": \"CNAME\",
          \"SetIdentifier\": \"green\",
          \"Weight\": $GREEN_WEIGHT,
          \"TTL\": 60,
          \"ResourceRecords\": [ { \"Value\": \"$GREEN_IP\" } ]
        }
      }
    ]
  }"
}

# Function to check health of the green deployment
check_green_health() {
  echo "Checking health of green environment..."
  # Replace this with a real health check endpoint if available
  curl -sSf "http://$GREEN_IP/health" >/dev/null
}

# Try switching to green
switch_traffic 0 100

# Wait for DNS to propagate
echo "Waiting for DNS to propagate..."
sleep 30

# Health check
if check_green_health; then
  echo "Green environment is healthy. Deployment successful."
else
  echo "Green environment failed health check. Rolling back..."
  switch_traffic 100 0
  echo "Rolled back to blue environment."
  exit 1
fi

