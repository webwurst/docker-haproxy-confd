FROM dockerfile/haproxy

# fixme curl

#COPY confd-0.6.3-linux-amd64 /usr/local/bin/confd
COPY confd-0.7.0-linux-amd64 /usr/local/bin/confd
RUN chmod u+x /usr/local/bin/confd

ADD configuration.toml /etc/confd/conf.d/configuration.toml
ADD haproxy.cfg /etc/confd/templates/haproxy.cfg

ADD start /start
RUN chmod u+x /start

#ENTRYPOINT ["/start"]

CMD ["/start", "-interval", "2", "-verbose", "-debug"]

# /start -interval 2 -verbose -debug -node=$ETCD_PORT_4001_TCP_ADDR:$ETCD_PORT_4001_TCP_PORT
