#!/usr/bin/env bash

set -ex

IMAGE="$1"

cd `dirname $0`

dgoss run -e "PORT=8082" "$IMAGE" node /srv/deploy/dist/server.js
