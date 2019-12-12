#!/usr/bin/env bash

set -exuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/_utils-cd.sh"

HELM_RELEASE_NAME="${PROJECT_NAME}"
HELM_NAMESPACE="default"
HELM_MONITORING_NAMESPACE="monitoring"

case "$ENV" in
    staging)
        HELM_ENV="staging"
        KUBE_DIR="${HOME}.kube-staging/"
        PROMETHEUS_RELOAD_URL="https://prometheus-kubernetes.staging.6cloud.fr/-/reload"
    ;;
    prod)
        HELM_ENV="prod"
        KUBE_DIR="${HOME}.kube/"
        PROMETHEUS_RELOAD_URL="https://prometheus-kubernetes.6cloud.fr/-/reload"
    ;;
    *)
        echo -e '\e[37;41mUnknown env '$ENV' -> ABORT and FAIL\e[0m'
        exit 1
esac

#############################################
## Push the application containers to AWS ECR
#############################################

ecr_login "$TARGET"

for dir in "$WORKSPACE"/.cloud/docker/* ; do
    if [[ ! -f "$dir/Dockerfile" ]]; then continue; fi
    ecr_push "$TARGET" "$(basename "$dir")" "$IMAGE_TAG"
done

#############################################
## Deploy by tenant
#############################################
TENANTS=""

if [[ -f "$WORKSPACE/.cloud/is-multi-tenant" ]]
then
    TENANTS="rtlmutu salto"
    CONFIGURED_TENANTS=$(sed -n -e '/BEGIN TENANT/,/END TENANT/{ /TENANT/d; p }' "$WORKSPACE/.cloud/is-multi-tenant")

    if [[ -n $CONFIGURED_TENANTS ]]
    then
        TENANTS=$CONFIGURED_TENANTS
    fi
fi

for TENANT in $TENANTS; do
    #######################################
    ## Deploy the migration with a Helm job
    #######################################

    test -d "$WORKSPACE/.cloud/charts/${PROJECT_NAME}-migration" && docker_helm \
        upgrade --install "${HELM_RELEASE_NAME}-${TENANT}-migration" "/tmp/charts/${PROJECT_NAME}-migration" \
        --namespace "$HELM_NAMESPACE" \
        --set-string env="$HELM_ENV" \
        --set-string dockerTag="$IMAGE_TAG" \
        --set-string tenant="$TENANT" \
        --wait

    ##################################################
    ## Deploy the application to Kubernetes, with Helm
    ##################################################

    docker_helm \
        upgrade --install "${HELM_RELEASE_NAME}-${TENANT}" "/tmp/charts/${PROJECT_NAME}" \
        --namespace "$HELM_NAMESPACE" \
        --set-string env="$HELM_ENV" \
        --set-string dockerTag="$IMAGE_TAG" \
        --set-string tenant="$TENANT" \
        --wait

    ####################################################################
    ## Deploy the monitoring rules to Kubernetes, then reload Prometheus
    ####################################################################

    if [[ "$ENV" == "prod" || "$ENV" == "staging" ]]; then
        test -d "$WORKSPACE/.cloud/charts/${PROJECT_NAME}-monitoring" && docker_helm \
            upgrade --install "${HELM_RELEASE_NAME}-${TENANT}-monitoring" "/tmp/charts/${PROJECT_NAME}-monitoring" \
            --namespace "$HELM_MONITORING_NAMESPACE" \
            --set-string env="$HELM_ENV" \
            --set-string dockerTag="$IMAGE_TAG" \
            --set-string tenant="$TENANT" \
            --wait

        curl -f -m 15 -X POST "$PROMETHEUS_RELOAD_URL" || true
    fi
done
