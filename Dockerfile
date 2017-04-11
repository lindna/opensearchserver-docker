FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y openjdk-7-jdk && apt-get install -y curl

RUN groupadd -g 100 opensearchserver || true
RUN useradd -m --gid 100 --uid 1032 -s /bin/bash -d /var/lib/opensearchserver opensearchserver

RUN curl -o opensearchserver.deb -L http://sourceforge.net/projects/opensearchserve/files/Stable_release/1.5.13/opensearchserver-1.5.13-2b6dfa4.deb/download

RUN dpkg -i opensearchserver.deb
RUN sed -e 's/OPENSEARCHSERVER_DATA=\/var\/lib\/opensearchserver\/data/OPENSEARCHSERVER_DATA=\/srv\/opensearchserver\/data/' -i /etc/opensearchserver

ADD start_opensearchserver.sh /start_opensearchserver.sh
RUN chmod +x /start_opensearchserver.sh

VOLUME ["/srv"]
WORKDIR /srv

EXPOSE 9090

CMD /start_opensearchserver.sh && tail -F /var/log/opensearchserver/server.out
