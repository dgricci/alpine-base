# Dockerfile for alpine based images
FROM alpine:3.8
MAINTAINER Didier Richard <didier.richard@ign.fr>
LABEL   version="1.0.0" \
        alpine="3.8" \
        gosu="1.10" \
        os="Alpine Linux" \
        description="Alpine Linux base image"

ARG GOSU_VERSION
ENV GOSU_VERSION ${GOSU_VERSION:-1.10}
ARG GOSU_DOWNLOAD_URL
ENV GOSU_DOWNLOAD_URL ${GOSU_DOWNLOAD_URL:-https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64}
# Default to UTF-8 file.encoding
ENV LANG "C.UTF-8"

# Cf. https://github.com/docker-library/golang/blob/master/1.6/wheezy/Dockerfile
COPY adduserifneeded.sh /usr/local/bin/adduserifneeded.sh
COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && rm -f /tmp/build.sh

# always launch this when starting a container (and then execute CMD ...)
ENTRYPOINT ["adduserifneeded.sh"]

#
CMD ["/bin/bash"]

