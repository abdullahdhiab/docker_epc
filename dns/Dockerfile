
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# Install updates and dependencies
RUN apt-get update && \
	apt-get -y install tcpdump screen tmux ntp ntpdate iproute2 net-tools \
					iputils-ping bind9

CMD /mnt/dns/dns_init.sh && \
	/usr/sbin/named -c /etc/bind/named.conf -g -u bind
