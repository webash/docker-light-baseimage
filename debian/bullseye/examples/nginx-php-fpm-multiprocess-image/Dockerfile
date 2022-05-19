FROM osixia/light-baseimage:2.0.0-debian

ENV CONTAINER_IMAGE_NAME=osixia/multiple-process-image-example \
    CONTAINER_IMAGE_TAG=2.0.0

RUN apt-get -y update \
    && /container/tools/add-multiprocess-stack \
    && packages-install-clean \
    nginx \
    php7.4-fpm 

ADD service /container/services

RUN /container/tools/install-services

ADD environment /container/environment/00-default

EXPOSE 80 443
