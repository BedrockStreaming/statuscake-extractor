FROM node:10.15.0-stretch-slim

# create a /deploy directory
RUN groupadd --system --gid 2001 m6group \
        && useradd --system --uid 1001 --group m6group m6user \
        && mkdir /srv/builder

# copy the project sources to the /deploy directory
COPY --chown=root:root ./design /srv/builder/design
COPY --chown=root:root ./packages /srv/builder/packages
WORKDIR /srv/builder/design

# install dependencies
RUN yarn && \
    yarn build

# Change user
USER m6user:m6group
