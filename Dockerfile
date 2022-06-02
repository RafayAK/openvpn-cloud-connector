# Building on 20.4-systemd base image as newer versions 
# of systemd (> 243) cause less DNS resolving problems
FROM jrei/systemd-ubuntu:20.04

LABEL maintainer="Rafay Khan <rafay.ahmad@veeve.io>"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
	curl \
	lsb-release \
	gnupg \
	python3-setuptools \
	net-tools \
	iptables \
	iproute2 \
	sudo
RUN apt-get clean all

# Install the OpenVPN repository key used by the OpenVPN packages
RUN curl -O https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub && \
	apt-key add openvpn-repo-pkg-key.pub && \
	rm -f openvpn-repo-pkg-key.pub

# Add the OpenVPN repository
RUN curl https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-focal.list -o /etc/apt/sources.list.d/openvpn3.list && \
	apt-get update

# Install OpenVPN Connector setup tool
RUN apt-get install -y python3-openvpn-connector-setup iptables-persistent

# Script to setup iptables rules
COPY ./iptables_setup.sh /usr/bin/iptables_setup.sh
RUN chmod +x /usr/bin/iptables_setup.sh

# systemd service for setting up iptable rules on boot
COPY ./iptables_setup.service /etc/systemd/system/iptables_setup.service
RUN chmod 644 /etc/systemd/system/iptables_setup.service

# connector configuration to handle initial boot and disconnections
COPY ./connector.autoload /etc/openvpn3/autoload/connector.autoload

# Download the prometheus script exporter to expose OpenVPN connector metrics
RUN curl -Ls https://github.com/ricoberger/script_exporter/releases/download/v2.5.2/script_exporter-linux-amd64 --output /usr/local/bin/script_exporter
RUN chmod +x /usr/local/bin/script_exporter

# Copy the exporter script, config, and systemd service
RUN mkdir -p /etc/script_exporter
COPY ./prometheus/config.yaml /etc/script_exporter/config.yaml
COPY ./prometheus/openvpn3.sh /etc/script_exporter/openvpn3.sh
COPY ./script_exporter.service /etc/systemd/system/script_exporter.service
RUN chmod 644 /etc/systemd/system/script_exporter.service

# enable iptables setup service and openvpn3 on boot
RUN systemctl enable iptables_setup.service
RUN systemctl enable script_exporter.service
RUN systemctl enable openvpn3-autoload.service

# ports at which openvpn3 runs.
EXPOSE 1194/udp 
EXPOSE 443/tcp

# prometheus metrics exporter
EXPOSE 9469/tcp
