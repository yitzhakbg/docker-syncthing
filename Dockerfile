FROM phusion/baseimage:0.9.16
MAINTAINER Yitzhak Bar Geva <yitzhakbargeva@gmail.com>

RUN useradd --no-create-home -g users --uid 22000 syncthing
# grab gosu for easy step-down from root
RUN apt-get update -qq \
  && apt-get install curl -y \
  && gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# get syncthing
ADD https://github.com/syncthing/syncthing/releases/download/v0.11.16/syncthing-linux-amd64-v0.11.16.tar.gz /srv/syncthing.tar.gz
WORKDIR /srv
RUN tar -xzvf syncthing.tar.gz \
  && rm -f syncthing.tar.gz \
  && mv syncthing-linux-amd64-v* syncthing \
  && chown -R syncthing:users syncthing \
  && mkdir -p /srv/config && chown syncthing:users /srv/config \
  && mkdir -p /srv/data && chown syncthing:users /srv/data

VOLUME ["/srv/data", "/srv/config"]

ADD ./start.sh /srv/start.sh
RUN chmod 770 /srv/start.sh && chown syncthing:users /srv/start.sh

ENTRYPOINT ["/srv/start.sh"]

