#!/bin/sh -l

set -e

#if [ "$(id -u)" -ne 0 ]; then
#  echo "This script must be run as root. Current UID: $(id -u)"
#  exit 1
#fi

# Start Docker daemon in background
#dockerd > /tmp/docker.log 2>&1 &

#echo "Waiting for Docker daemon to be ready..."
#if ! timeout 15 bash -c 'until docker info > /dev/null 2>&1; do sleep 1; done'; then
#  echo "Docker daemon did not become ready in time. Showing log:"
#  tail -n 20 /tmp/docker.log
#  exit 1
#fi

# Retrieve a short lived runner registration token using the PAT
REGISTRATION_TOKEN="$(curl -X POST -fsSL \
  -H 'Accept: application/vnd.github.v3+json' \
  -H "Authorization: Bearer $GITHUB_PAT" \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  "$REGISTRATION_TOKEN_API_URL" \
  | jq -r '.token')"

./config.sh --url $GH_URL --token $REGISTRATION_TOKEN --unattended --ephemeral
./run.sh
