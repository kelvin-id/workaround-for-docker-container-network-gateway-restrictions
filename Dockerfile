FROM ubuntu
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y iproute2 inetutils-ping curl host mtr-tiny tcpdump iptables traceroute \
    && rm -rf /var/lib/apt/lists/*
