# Building on 20.4-systemd base image as newer versions 
# of systemd (> 243) cause less DNS resolving problems
FROM jrei/systemd-ubuntu:20.04

LABEL maintainer="Rafay Khan <rafay.ahmad@veeve.io>"

RUN apt update &&                               \
    apt install -y curl &&                      \
    apt install -y lsb-release &&               \
    apt install -y gnupg &&                     \
    apt install -y python3-setuptools &&        \
    apt install -y net-tools &&                 \
    apt install -y iptables &&                  \
    apt install -y iproute2 &&                  \
    apt install -y sudo &&                      \
    apt clean all

# install openvpn3 connector
COPY ./ubuntu_20_04.sh /tmp/ubuntu_20_04.sh
RUN chmod +x /tmp/ubuntu_20_04.sh && sh /tmp/ubuntu_20_04.sh

# script to setup iptable rules
COPY ./iptables_setup.sh /usr/bin/iptables_setup.sh
RUN chmod +x /usr/bin/iptables_setup.sh

# systemd service for setting up iptable rules on boot
COPY ./iptables_setup.service /etc/systemd/system/iptables_setup.service
RUN chmod 644 /etc/systemd/system/iptables_setup.service

# connector configuration to handle initial boot and disconnections
COPY ./connector.autoload /etc/openvpn3/autoload/connector.autoload

# enable iptables setup service and openvpn3 on boot
RUN systemctl enable iptables_setup.service
RUN systemctl enable openvpn3-autoload.service

# ports at which openvpn3 runs.
EXPOSE 1194/udp 
EXPOSE 443/tcp
