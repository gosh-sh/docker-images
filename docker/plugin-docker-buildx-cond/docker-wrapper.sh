#!/bin/sh
set -eu

if [ "${1:-}" = "buildx" ] && [ "${2:-}" = "create" ] && [ -n "${PLUGIN_BUILDKIT_IMAGE:-}" ]; then
  echo "+ pinning BuildKit image to ${PLUGIN_BUILDKIT_IMAGE}"
  exec /usr/local/bin/docker-original "$@" --driver-opt "image=${PLUGIN_BUILDKIT_IMAGE}"
fi

exec /usr/local/bin/docker-original "$@"
