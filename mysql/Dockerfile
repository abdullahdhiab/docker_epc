
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# Install updates and dependencies
RUN apt-get update && \
    apt-get -y install mysql-server ca-certificates

ADD mysql_init.sh /mysql_init.sh
RUN chmod 755 /mysql_init.sh

RUN /etc/init.d/mysql stop

CMD /mysql_init.sh
