# Containerized OpenVPN Cloud Connector
This container encapsulates the OpenVPN Cloud Connector, along with SystemD and Dbus for easy deployment and encapsulation from the host environment.


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
- Mount the connector file to  `/etc/openvpn3/autoload/connector.conf` volume in the container, using the command below:
- Finally, run the docker command below (make sure to replace path to connector file):

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



---

More info on OpenVPN Cloud Connectors could be found here: https://openvpn.net/cloud-docs/connector/

Built on top of @jrei gracious work. https://hub.docker.com/r/jrei/systemd-ubuntu

Feel free to connect on Twitter [@RafayAK] (https://twitter.com/RafayAK)
