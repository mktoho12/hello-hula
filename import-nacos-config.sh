#!/bin/bash

# Nacos configuration import script
NACOS_ADDR="http://localhost:8848"
NACOS_USERNAME="nacos"
NACOS_PASSWORD="nacos"
NACOS_NAMESPACE="public"
CONFIG_DIR="./nacos-config/DEFAULT_GROUP"

echo "Waiting for Nacos to be ready..."
until curl -sf "${NACOS_ADDR}/nacos/v1/console/health/liveness" > /dev/null 2>&1; do
  echo "Waiting for Nacos..."
  sleep 3
done

echo "Nacos is ready. Importing configurations..."

# Import all YAML files
for config_file in ${CONFIG_DIR}/*.yml; do
  if [ -f "$config_file" ]; then
    filename=$(basename "$config_file")
    dataId="${filename}"

    echo "Importing ${dataId}..."

    curl -X POST "${NACOS_ADDR}/nacos/v1/cs/configs" \
      -d "dataId=${dataId}" \
      -d "group=DEFAULT_GROUP" \
      -d "content=$(cat ${config_file})" \
      -d "type=yaml" \
      -d "tenant=${NACOS_NAMESPACE}" \
      --data-urlencode "username=${NACOS_USERNAME}" \
      --data-urlencode "password=${NACOS_PASSWORD}"

    echo ""
  fi
done

echo "Configuration import completed!"
