#!/usr/bin/env bash

set -exuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/_utils-cd.sh"

##################################################
## Login on ECR
# This is required *before* docker build, as the FROM in our Dockerfile
# references the base-image on ECR.
##################################################

# using subshells to not overwrite AWS cli credentials
(ecr_login "services")
if [[ ! "$TARGET" == "$?" ]]; then
    (ecr_login "$TARGET")
fi

##################################################
## Build docker images
## and check they are OK
##################################################

case "$TARGET" in
    services)
        IMAGE_REPOSITORY="$AWS_ACCOUNT_SERVICES.dkr.ecr.$AWS_REGION_SERVICES.amazonaws.com"
    ;;
    staging)
        IMAGE_REPOSITORY="$AWS_ACCOUNT_STAGING.dkr.ecr.$AWS_REGION_STAGING.amazonaws.com"
    ;;
    *)
        echo "Invalid target $TARGET"
        exit 1
    ;;
esac

## PHP

IMAGE_NODE_FULL="$(ecr_image "$TARGET" node "$IMAGE_TAG")"

docker_build \
    --target "${RUNTIME:-prod}" \
    --file ".cloud/docker/node/Dockerfile" \
    --tag "$IMAGE_NODE_FULL"

"$WORKSPACE"/.cloud/docker/node/tests/tests.sh "$IMAGE_NODE_FULL"

##################################################
## Summary of 'build' step
##################################################

set +x
echo "==========================================="
echo "New docker images built for $PROJECT_NAME:"
echo "  * node"
echo "     * Full path: $IMAGE_NODE_FULL"
echo ""
echo "To deploy this version of the application,"
echo "you will need the Tag of this build:"
echo "  -> $IMAGE_TAG"
echo "==========================================="
set -x
