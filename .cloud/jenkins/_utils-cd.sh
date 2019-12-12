#!/usr/bin/env bash

########################################################################################################################
##
## Dans ce fichier, uniquement des fonctions IDENTIQUES entre tous les projets -- il sera mutualisé un jour (?)
## src: https://github.m6web.fr/sysadmin/cloud-deployer/blob/master/_utils-cd.sh
##
########################################################################################################################

# Quick explanation of a bash pattern you will see occuring in this file:
# `"AWS_ACCOUNT_${1^^}"` uppercases the variable to get AWS_ACCOUNT_SERVICES
# `${!account}` resolve the variable value

##################################################
## Validate the target account from whitelist
# __validate_target [services|staging]
##################################################
__validate_target() {
    case "$1" in "services" | "staging") return 0 ;; esac
    echo "invalid target $1" >&2
    return 1
}

##################################################
## Login to AWS by assuming a role from our jenkins user
# aws_login [services|staging] [role_name]
##################################################
aws_login() {
    if ! __validate_target "$1"; then
        return 1
    fi

    local account="AWS_ACCOUNT_${1^^}"
    local region="AWS_REGION_${1^^}"
    AWS_ACCOUNT="${!account}"
    AWS_REGION="${!region}"

    export AWS_DEFAULT_REGION="$AWS_REGION"
    AWS_ROLE_NAME="${2:-jenkins-ecr}"
    AWS_ACCOUNT_ARN="arn:aws:iam::$AWS_ACCOUNT"

    # Login to ECR (via AssumeRole)
    # Hiding the command, to prevent having a full login command in the log :-/
    set +x
    AWS_STS="$(aws sts assume-role \
        --role-arn "$AWS_ACCOUNT_ARN:role/$AWS_ROLE_NAME" \
        --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken,Credentials.Expiration]' \
        --output text \
        --role-session-name "$(tr / - <<< "$AWS_ROLE_NAME")"\
    )"

    export AWS_ACCESS_KEY_ID="$(awk '{print $1}' <<< "$AWS_STS")"
    export AWS_SECRET_ACCESS_KEY="$(awk '{print $2}' <<< "$AWS_STS")"
    export AWS_SECURITY_TOKEN="$(awk '{print $3}' <<< "$AWS_STS")"
    export AWS_SESSION_TOKEN="$(awk '{print $3}' <<< "$AWS_STS")"
    set -x
}

##################################################
## Get ECR's FQDN
# ecr_login [services|staging]
##################################################
ecr_repo() {
    if ! __validate_target "$1"; then
        return 1
    fi

    local account="AWS_ACCOUNT_${1^^}"
    local region="AWS_REGION_${1^^}"
    echo "${!account}.dkr.ecr.${!region}.amazonaws.com"
}

##################################################
## Login on ECR
# ecr_login [services|staging]
##################################################
ecr_login() {
    aws_login "$1"

    # docker login -u AWS -p ...
    set +x
    $(\
        AWS_ACCESS_KEY_ID="$(awk '{print $1}' <<< "$AWS_STS")" \
        AWS_SECRET_ACCESS_KEY="$(awk '{print $2}' <<< "$AWS_STS")" \
        AWS_SECURITY_TOKEN="$(awk '{print $3}' <<< "$AWS_STS")" \
        AWS_SESSION_TOKEN="$(awk '{print $3}' <<< "$AWS_STS")" \
        aws ecr get-login --no-include-email --region "$AWS_REGION"\
    )
    set -x
}

##################################################
## Normed image name
# ecr_image [services|staging] [nginx|php|node] 20190213164003-master
##################################################
ecr_image() {
    local repo
    repo="$(ecr_repo "$1")"
    local image="$PROJECT_NAME-$2"
    local tag="$3"

    echo "$repo/$image:$tag"
}

##################################################
## Push to ECR
# ecr_push [services|staging] [nginx|php|node] 20190213164003-master
##################################################
ecr_push() {
    local image
    image="$(ecr_image "$1" "$2" "$3")"

    docker push "$image"
}

##################################################
## docker build
# alias for `docker build` with some build-arg preset
# docker_build [...]
##################################################
docker_build() {
    docker build --rm \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg WORKSPACE="." \
        --build-arg SOURCES_DIR="." \
        --build-arg VCS_URL="$GIT_URL" \
        --build-arg VCS_REF="$GIT_COMMIT" \
        "$@" \
        "${WORKSPACE:-.}"
}

##################################################
## helm
# alias for dockerised helm with the charts mounted
# docker_helm [...]
##################################################
docker_helm() {
    local img="DOCKER_IMAGE_HELM_${HELM_ENV^^}"
    local ctxt="HELM_KUBE_CONTEXT_${HELM_ENV^^}"
    DOCKER_IMAGE_HELM="${!img}"
    HELM_KUBE_CONTEXT="${!ctxt}"

    docker run --rm \
    -v "$KUBE_DIR:/root/.kube/:ro,z" \
    -v "$WORKSPACE/.cloud/charts/:/tmp/charts/:ro,z" \
    "$DOCKER_IMAGE_HELM" \
    --kube-context="$HELM_KUBE_CONTEXT" \
    "$@"
}

##################################################
## kubectl
# alias for dockerised kubectl
# docker_kubectl [...]
##################################################
docker_kubectl() {
    local img="DOCKER_IMAGE_KUBECTL_${HELM_ENV^^}"
    local ctxt="HELM_KUBE_CONTEXT_${HELM_ENV^^}"
    DOCKER_IMAGE_KUBECTL="${!img}"
    HELM_KUBE_CONTEXT="${!ctxt}"

    docker run --rm \
    -v "$KUBE_DIR:/root/.kube/:ro,z" \
    "$DOCKER_IMAGE_KUBECTL" \
    --context="$HELM_KUBE_CONTEXT" \
    "$@"
}

##################################################
## wait&see
# wait for a command to succeed and return its output
# wait_and_see 'ls | grep unicorn'
##################################################
wait_and_see() {
    set +ex
    _cmd=$*
    until eval "$_cmd"
    do
        echo "$_cmd returned $?, retry in 5s"
        sleep 5s
    done
}

##################################################
## debug_deployment
# executes helm diagnosis commands, then executes probes code
# debug_deployment service-6play-test default rtlmutu
##################################################
debug_deployment() {
    set +x
    echo "

     ######################################################################################
     #                                                                                    #
     #                               DEBUG OUTPUT BELOW                                   #
     #              You shall find common cloud debugging commands output                 #
     #                              like helm and kubectl                                 #
     #                                                                                    #
     ######################################################################################

"
    set -x

    project=$1
    namespace=$2
    tenant=$3

    docker_helm \
        list "$project-$tenant" \
        --namespace "$namespace"
    
    docker_kubectl \
        get all \
        --namespace "$namespace" \
        -l "project=$project,tenant=$tenant"

    docker_kubectl \
        get pods \
        --namespace "$namespace" \
        -l "project=$project,tenant=$tenant" \
        -o jsonpath="{.items[0].metadata.name}"
    
    pod_name=$(docker_kubectl get pods --namespace "$namespace" -l "project=$project,tenant=$tenant" -o jsonpath="{.items[0].metadata.name}")

    docker_kubectl get pods -n "$namespace" -ojson | jq -c --arg PN "$pod_name" 'select(.items[].metadata.name == $PN) | .items[0].spec.containers[] | select(.name == "php") | { "readiness": last(.readinessProbe.exec.command[]), "liveness": last(.livenessProbe.exec.command[]) }' \
        | while read -r line; do
        debug_probes "$line" "$namespace" "$pod_name"
    done
}

##################################################
## debug_probes
# launches php probes code on the given pod
# debug_probes '{"liveness":"echo test", "readiness":"echo test"}' service-6play-test-42 service-6play-test-42-12abc-4512
##################################################
debug_probes() {
    readiness=$(jq -r .readiness <<<"$1" | cut -d\| -f1)
    liveness=$(jq -r .liveness <<<"$1" | cut -d\| -f1)
    namespace="$2"
    pod="$3"

    set +e

    echo -e "Testing readiness \`\e[1m$readiness\e[0m\`" >&2

    docker_kubectl \
        -n "$namespace" \
        exec "$pod" \
        -c php \
        -- bash -c "$readiness"

    docker_kubectl \
        logs "$pod" \
        -n "$namespace" \
        -c php

    echo -e "Testing liveness \`\e[1m$liveness\e[0m\`" >&2
    
    docker_kubectl \
        -n "$namespace" \
        exec "$pod" \
        -c php \
        -- bash -c "$liveness"

    docker_kubectl \
        logs "$pod" \
        -n "$namespace" \
        -c php

    set -e
}
