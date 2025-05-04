#!/bin/sh -l

set -e

# Start Docker daemon in background
dockerd > /tmp/docker.log 2>&1 &

# Wait for Docker to become responsive
timeout 15 bash -c 'until docker info > /dev/null 2>&1; do sleep 1; done'

# Retrieve a short lived runner registration token using the PAT
REGISTRATION_TOKEN="$(curl -X POST -fsSL \
  -H 'Accept: application/vnd.github.v3+json' \
  -H "Authorization: Bearer $GITHUB_PAT" \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  "$REGISTRATION_TOKEN_API_URL" \
  | jq -r '.token')"

./config.sh --url $GH_URL --token $REGISTRATION_TOKEN --unattended --ephemeral
./run.sh
