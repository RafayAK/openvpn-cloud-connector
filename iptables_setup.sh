DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo "IPtables rules setup service started at ${DATE}" | systemd-cat -p info

IF=`ip route | grep default | awk '{print $5}'`
echo "Default interface: ${IF}"
iptables -I FORWARD -i tun+ -j ACCEPT
iptables -t nat -A POSTROUTING -o $IF -j MASQUERADE
iptables-save | sudo tee /etc/iptables/rules.v4
ip6tables -t nat -A POSTROUTING -o $IF -j MASQUERADE
iptables-save | sudo tee /etc/iptables/rules.v6
