#FROM nghiant2710/device-sync:jessie-node-5.3.0
FROM registry.resin.io/thethree/e8a814cde212fe5b5c879437f3189f31bee55d10
# Add the apt sources for raspbian
RUN echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free rpi firmware" >>  /etc/apt/sources.list
RUN apt-key adv --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E

# Install dependencies.
RUN apt-get update \
	&& apt-get install -yq wget \
	# Remove package lists to free up space
	&& rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN wget https://nodejs.org/dist/v4.0.0/node-v4.0.0-linux-armv7l.tar.gz && \
		tar -xvf node-v4.0.0-linux-armv7l.tar.gz && \
		cd node-v4.0.0-linux-armv7l && \
		cp -R * /usr/local/

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
