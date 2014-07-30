FROM luis/nodejs
MAINTAINER Luis Elizondo "lelizondo@gmail.com"

RUN apt-get update
RUN apt-get -qq update

RUN apt-get install -qy supervisor unzip git
RUN mkdir -p /var/log/supervisor

RUN apt-get update --fix-missing

WORKDIR /

# Let's get serf
ADD https://dl.bintray.com/mitchellh/serf/0.6.1_linux_amd64.zip serf.zip
RUN unzip serf.zip
RUN mv serf /usr/bin/
RUN rm serf.zip

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get remove --purge -y unzip
RUN apt-get autoremove -y

# Add serf scripts
ADD ./scripts/start-serf.sh /start-serf.sh
ADD ./scripts/serf-join.sh /serf-join.sh
ADD ./scripts/serf-members.sh /serf-members.sh
RUN chmod 755 /*.sh

# Add configuration
ADD ./config/supervisord.conf /etc/supervisor/conf.d/supervisord-serf.conf

EXPOSE 3000

WORKDIR /var/www

VOLUME ["/var/files", "/var/www"]

CMD ["/usr/bin/supervisord", "-n"]
