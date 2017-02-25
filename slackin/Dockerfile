FROM node:slim

ARG SLACKIN_VERSION=0.13.0
RUN npm install --global --unsafe-perm slackin@$SLACKIN_VERSION

CMD slackin "$SLACK_SUBDOMAIN" "$SLACK_TOKEN"
