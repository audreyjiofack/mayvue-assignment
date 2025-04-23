#!/bin/bash

HOSTED_ZONE_ID="Z123456ABCDEFG"
RECORD_NAME="app.mayvue.com."
BLUE_IP="blue.mayvue.com"
GREEN_IP="green.mayvue.com"          

echo "Starting Blue-Green Deployment switch..."

aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'"$RECORD_NAME"'",
        "Type": "CNAME",
        "SetIdentifier": "blue",
        "Weight": 0,
        "TTL": 60,
        "ResourceRecords": [ { "Value": "'"$BLUE_IP"'" } ],
        "Weight": 0
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'"$RECORD_NAME"'",
        "Type": "CNAME",
        "SetIdentifier": "green",
        "Weight": 100,
        "TTL": 60,
        "ResourceRecords": [ { "Value": "'"$GREEN_IP"'" } ]
      }
    }
  ]
}'

echo "Traffic successfully switched to GREEN environment."
