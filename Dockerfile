#FROM dockerfile/haproxy
#FROM busybox:buildroot-2014.02
#FROM ubuntu-14.04

FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# haproxy
RUN apt-get update && apt-get install -y curl build-essential make g++ libssl-dev \
  && curl -L http://www.haproxy.org/download/1.5/src/haproxy-1.5.8.tar.gz \
    | tar -xz --directory /tmp --strip-components 1 \
  && cd /tmp \
  && make USE_OPENSSL=1 TARGET=generic \
  && make install \
  && apt-get purge -y curl build-essential make g++ libssl-dev \
  && apt-get autoremove -y \
  && rm -rf /tmp/* \
  && mkdir -p /etc/haproxy

  # FIXME! checksum
  # http://louwrentius.com/how-to-compile-haproxy-from-source-and-setup-a-basic-configuration.html

# confd
RUN apt-get update && apt-get install -y curl \
  && curl -L https://github.com/kelseyhightower/confd/releases/download/v0.7.0-beta1/confd-0.7.0-linux-amd64 \
    > /usr/local/bin/confd \
  && chmod u+x /usr/local/bin/confd

# config
COPY configuration.toml /etc/confd/conf.d/
COPY haproxy.cfg /etc/confd/templates/
COPY confd_run /usr/local/bin/
RUN chmod u+x /usr/local/bin/confd_run

CMD ["confd_run"]
