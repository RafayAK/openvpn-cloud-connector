# Containerized OpenVPN Cloud Connector
This container encapsulates the OpenVPN Cloud Connector, along with SystemD and Dbus for easy deployment.


## To build 

 To build `cd` into `openvpn-cloud-connector` directory after cloning and run the following Docker build command:

 ```bash
# build 
docker build --tag ovpn-connector .

 ```

## How to run


To run:
- Download the OpenVPN cloud connector file for a network (`connectorXX_region.opvn`) 
- Optionally, save the connector file to the `ovpn-connector` directory, for easy identification
- Mount the connector file to  `/etc/openvpn3/autoload/connector.conf` volume in the container, using the command below and run:

```bash
docker run -d --restart always --name ovpn_connector.docker -p 1194:1194/udp -p 443:443/tcp --privileged -v /<YOUR>/<PATH>/<TO>/connectorXX_region.opvn:/etc/openvpn3/autoload/connector.conf -v /sys/fs/cgroup:/sys/fs/cgroup:ro ovpn-connector

```

With the `--restart always` directive this docker container will automatically start on each system boot or docker daemon restart.

## How to remove the container

To remove this container run the following command:

```bash
docker container rm -f ovpn_connector.docker

# Additionally to remove the image
docker image rm ovpn_connector.docker

```


# Don't want to / Can't build the Docker image

Use the Docker image on my Docker hub instead:

https://hub.docker.com/r/rafayak/ovpn-connector

```bash
# Pull the image
docker pull rafayak/ovpn-connector

# Run the container. Make sure to replace the path to your connector file
docker run -d --restart always --name ovpn_connector.docker -p 1194:1194/udp -p 443:443/tcp --privileged -v /<YOUR>/<PATH>/<TO>/connectorXX_region.opvn:/etc/openvpn3/autoload/connector.conf -v /sys/fs/cgroup:/sys/fs/cgroup:ro rafayak/ovpn-connector

# To stop and remove the container
docker container rm -f ovpn_connector.docker

# Additionally to remove the image
docker image rm rafayak/ovpn-connector
```

# Why use containerized OpenVPN Cloud connector?

The main reason for using a containerized connector is to encapsulate the changes by OpenVPN3 (the new OpenVPN framework) from the host machine.

The OpenVPN3 linux client makes chnages to the DNS configurations and IPtables; it also uses the host machines port `1194` and `443` to function correctly. If you run many applications/services on the host machine that rely on bespoke DNS and IPtable rules or run on specific ports that OpenVPN3 requires then OpenVPN3 can bring all or some of your serivices to a halt. Degugging the DNS and IPtables route issues can also be a massive time sink. Furthermore, the setup of a OpenVPN Cloud connector requires enabling IP-forwarding on the host which may not be desireable in some circumstances. Therefore, a containerized OpenVPN Cloud connector saves the host machine from changes that may affect your services.


---

More info on OpenVPN Cloud Connectors could be found here: https://openvpn.net/cloud-docs/connector/

Built on top of @jrei gracious work. https://hub.docker.com/r/jrei/systemd-ubuntu

Feel free to connect on Twitter [@RafayAK] (https://twitter.com/RafayAK)
