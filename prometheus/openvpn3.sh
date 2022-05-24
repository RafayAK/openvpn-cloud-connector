#!/bin/bash

# Get the connector config name, network, and org name.
# Here we also convert spaces to '_' and lowercase them so they can be used
# as labels.
CONF_USER=$(grep OVPN_WEBAUTH_FRIENDLY_USERNAME /etc/openvpn3/autoload/connector.conf | cut -d'=' -f2)
ORG_NAME=$(echo "${CONF_USER}" | cut -d'/' -f1)
ORG_NAME=${ORG_NAME// /_}
ORG_NAME=${ORG_NAME,,}
NET_NAME=$(echo "${CONF_USER}" | cut -d'/' -f2)
NET_NAME=${NET_NAME// /_}
NET_NAME=${NET_NAME,,}
CONNECTOR_NAME=$(echo "${CONF_USER}" | cut -d'/' -f3)
CONNECTOR_NAME=${CONNECTOR_NAME// /_}
CONNECTOR_NAME=${CONNECTOR_NAME,,}

# Fetch session details
SESSIONS=$(openvpn3 sessions-list)
SESSION_PATH=$(echo "${SESSIONS}" | grep 'Path:' | awk '{print $2}')
SESSION_STATUS=$(echo "${SESSIONS}" | grep 'Status:' | cut -d':' -f2 | sed 's/^ *//g')
SESSION_NAME=$(echo "${SESSIONS}" | grep 'Session name:' | cut -d':' -f2 | sed 's/^ *//g')
if [[ "${SESSION_STATUS}" == "Connection, Client connected" ]]; then
	SESSION_STATUS=1
else
	SESSION_STATUS=0
fi

# Fetch session stats
STATS=$(openvpn3 session-stats --path "${SESSION_PATH}")
STAT_BYTES_IN=$(echo "$STATS" | grep ' BYTES_IN' | grep -o '[[:digit:]]*')
STAT_BYTES_OUT=$(echo "$STATS" | grep ' BYTES_OUT' | grep -o '[[:digit:]]*')
STAT_PACKETS_IN=$(echo "$STATS" | grep ' PACKETS_IN' | grep -o '[[:digit:]]*')
STAT_PACKETS_OUT=$(echo "$STATS" | grep ' PACKETS_OUT' | grep -o '[[:digit:]]*')
STAT_TUN_BYTES_IN=$(echo "$STATS" | grep ' TUN_BYTES_IN' | grep -o '[[:digit:]]*')
STAT_TUN_BYTES_OUT=$(echo "$STATS" | grep ' TUN_BYTES_OUT' | grep -o '[[:digit:]]*')
STAT_TUN_PACKETS_IN=$(echo "$STATS" | grep ' TUN_PACKETS_IN' | grep -o '[[:digit:]]*')
STAT_TUN_PACKETS_OUT=$(echo "$STATS" | grep ' TUN_PACKETS_OUT' | grep -o '[[:digit:]]*')

# Output the metrics
echo "# HELP connector_session_connected"
echo "# TYPE connector_session_connected gauge"
echo "connector_session_connected{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${SESSION_STATUS}"
echo ""
echo "# HELP connector_bytes_in"
echo "# TYPE connector_bytes_in counter"
echo "connector_bytes_in{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_BYTES_IN}"
echo ""
echo "# HELP connector_bytes_out"
echo "# TYPE connector_bytes_out counter"
echo "connector_bytes_out{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_BYTES_OUT}"
echo ""
echo "# HELP connector_packets_in"
echo "# TYPE connector_packets_in counter"
echo "connector_packets_in{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_PACKETS_IN}"
echo ""
echo "# HELP connector_packets_out"
echo "# TYPE connector_packets_out counter"
echo "connector_packets_out{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_PACKETS_OUT}"
echo ""
echo "# HELP connector_tunnel_bytes_in"
echo "# TYPE connector_tunnel_bytes_in counter"
echo "connector_tunnel_bytes_in{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_TUN_BYTES_IN}"
echo ""
echo "# HELP connector_tunnel_bytes_out"
echo "# TYPE connector_tunnel_bytes_out counter"
echo "connector_tunnel_bytes_out{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_TUN_BYTES_OUT}"
echo ""
echo "# HELP connector_tunnel_packets_in"
echo "# TYPE connector_tunnel_packets_in counter"
echo "connector_tunnel_packets_in{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_TUN_PACKETS_IN}"
echo ""
echo "# HELP connector_tunnel_packets_out"
echo "# TYPE connector_tunnel_packets_out counter"
echo "connector_tunnel_packets_out{org=\"${ORG_NAME}\",network=\"${NET_NAME}\",connector=\"${CONNECTOR_NAME}\"} ${STAT_TUN_PACKETS_OUT}"
