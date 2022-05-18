FROM osixia/light-baseimage:2.0.0-debian

ENV CONTAINER_IMAGE=osixia/single-process-image-example:2.0.0

RUN apt-get -y update \
    && packages-install-clean \
    nginx

COPY service /container/services

RUN /container/tools/install-services

COPY environment /container/environment/00-default

EXPOSE 80 443
