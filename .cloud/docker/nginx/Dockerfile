FROM 908538848727.dkr.ecr.eu-west-3.amazonaws.com/base-nginx-php:20190131160643

LABEL maintainer="M6Web"

# Copying config files
ARG SOURCES_DIR
COPY $SOURCES_DIR/.cloud/docker/nginx/image-root/ /

ARG BUILD_DATE
ARG VCS_TYPE=git
ARG VCS_URL
ARG VCS_REF
LABEL build-date=$BUILD_DATE \
    vcs-type=$VCS_TYPE \
    vcs-url=$VCS_URL \
    vcs-ref=$VCS_REF
