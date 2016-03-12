#FROM nghiant2710/device-sync:jessie-node-5.3.0
FROM registry.resin.io/thethree/e8a814cde212fe5b5c879437f3189f31bee55d10

# These env vars enable sync_mode on all devices. To set these only on a
# specific device, set them from the resin.io dashboard.
ENV SSH_PORT=8080
ENV SYNC_MODE=on
ENV INITSYSTEM=on

# Use apt-get to install any dependencies
RUN apt-get update && apt-get install -yq --no-install-recommends \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Currently resin-sync will always sync to /usr/src/app, so code needs to be here.
WORKDIR /usr/src/app

# package.json is copied separately to enable better docker build caching
COPY package.json package.json

# Install only production dependencies from npm
RUN DEBIAN_FRONTEND=noninteractive JOBS=MAX npm install --unsafe-perm --production --loglevel error

# copy current directory into WORKDIR
COPY . ./

# Start you node app, "start" defined in the package.json scripts section.
CMD [ "npm", "start"]
