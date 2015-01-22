FROM debian:wheezy

MAINTAINER Marian Steinbach <marian@giantswarm.io>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y -q && \
  apt-get install -y mysql-client-5.5 python-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN pip install awscli

ADD backup.sh /backup.sh
RUN chmod 0755 /backup.sh

CMD /backup.sh
