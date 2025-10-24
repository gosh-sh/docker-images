#!/bin/sh

echo "Starting!"

if [ "$PLUGIN_SKIP_IF_TAG_EXISTS" != "" ]; then
  if [ "$PLUGIN_SKIP_REGISTRY_URL" != "" ]; then
    reg_username=$(echo "$PLUGIN_LOGINS" | jq -r ". | map(select(.registry == \"$PLUGIN_SKIP_REGISTRY_URL\"))[0].username")
    reg_password=$(echo "$PLUGIN_LOGINS" | jq -r ". | map(select(.registry == \"$PLUGIN_SKIP_REGISTRY_URL\"))[0].password")
    echo "Log in $reg_username to $PLUGIN_SKIP_REGISTRY_URL"
    docker login -u "$reg_username" -p "$reg_password" "$PLUGIN_SKIP_REGISTRY_URL" 2>/dev/null
    exit_code=$?
    unset reg_username reg_password
  else
    reg_username=$(echo "$PLUGIN_LOGINS" | jq -r ". | map(select(.registry == null))[0].username")
    reg_password=$(echo "$PLUGIN_LOGINS" | jq -r ". | map(select(.registry == null))[0].password")
    echo "Log in $reg_username to default registry"
    docker login -u "$reg_username" -p "$reg_password" 2>/dev/null
    exit_code=$?
    unset reg_username reg_password
  fi
  if [ $exit_code -ne 0 ]; then
    echo "Login failed"
    exit 1
  fi
  echo "Checking for $PLUGIN_REPO:$PLUGIN_SKIP_IF_TAG_EXISTS"
  docker manifest inspect "$PLUGIN_REPO:$PLUGIN_SKIP_IF_TAG_EXISTS" | grep digest
  exit_code=$?
  rm -f ~/.docker/config.json
  if [ $exit_code -eq 0 ]; then
    echo "$PLUGIN_REPO:$PLUGIN_SKIP_IF_TAG_EXISTS already exists, skipping build"
    exit 0
  else
    echo "$PLUGIN_REPO:$PLUGIN_SKIP_IF_TAG_EXISTS does not exist, continuing"
  fi
fi

exec plugin-docker-buildx
