FROM osixia/light-baseimage:2.0.0-debian

ENV CONTAINER_IMAGE=osixia/multiple-process-image-example:2.0.0

RUN apt-get -y update \
    && /container/tools/add-multiple-process-stack \
    && install-and-clean \
    nginx \
    php7.4-fpm 

ADD service /container/service

RUN /container/tools/install-services

ADD environment /container/environment/00-default

EXPOSE 80 443
