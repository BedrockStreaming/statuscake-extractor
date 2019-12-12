# ---- Base ----
FROM node:12.9.1 AS base

COPY  $SOURCES_DIR /srv/deploy
WORKDIR /srv/deploy

RUN groupadd --system --gid 2001 m6group \
  && useradd --system --uid 1001 --group m6group m6user

RUN yarn

ENV NODE_ENV production
ENTRYPOINT ["yarn","start"]


ARG VCS_TYPE=git
ARG VCS_URL
ARG VCS_REF
ARG BUILD_DATE
LABEL build-date=$BUILD_DATE \
  vcs-type=$VCS_TYPE \
  vcs-url=$VCS_URL \
  vcs-ref=$VCS_REF