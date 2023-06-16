
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget && \
    wget -q https://github.com/prometheus/prometheus/releases/download/v2.40.2/prometheus-2.40.2.linux-amd64.tar.gz && \
    tar xvfz prometheus-2.40.2.linux-amd64.tar.gz

WORKDIR prometheus-2.40.2.linux-amd64

CMD /mnt/metrics/metrics_init.sh
