#!/usr/bin/env bash

set -ex

IMAGE="$1"

cd `dirname $0`
dgoss run "$IMAGE" /usr/sbin/nginx
