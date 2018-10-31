#!/bin/sh
# Dockerfile for alpine based images

# FIXME : https://github.com/rilian-la-te/musl-locales

apk update
apk add --no-cache \
    bash \
    file \
    ca-certificates \
    curl \
    wget \
    git \
    openssh-client \
    gnupg \
    zip \
    unzip \
    coreutils \
    procps
rm -rf /var/cache/apk/*

# Try different servers as one can be timed out (Cf. https://github.com/tianon/gosu/issues/39) :
for server in ha.pool.sks-keyservers.net \
    hkp://p80.pool.sks-keyservers.net:80 \
    keyserver.ubuntu.com \
    hkp://keyserver.ubuntu.com:80 \
    pgp.mit.edu ; do
    gpg --keyserver "${server}" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || echo "Trying new server..."
done

curl -fsSL "$GOSU_DOWNLOAD_URL" -o /usr/bin/gosu && \
curl -fsSL "${GOSU_DOWNLOAD_URL}.asc" -o /usr/bin/gosu.asc && \
gpg --verify /usr/bin/gosu.asc && \
rm -f /usr/bin/gosu.asc && \
chmod +x /usr/bin/gosu && \
# See https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker
ln -s /lib/ld-musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 && \
mkdir /lib64 && ln -s /lib/ld-musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

