#!/usr/bin/env bash

set -ex

IMAGE="$1"

cd `dirname $0`
dgoss run -i -t "$IMAGE" /bin/bash
