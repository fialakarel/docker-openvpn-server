# OpenVPN server

## Start OpenVPN server

The `<path-to-vpn-folder>` should contain all the necessary config files for starting the VPN server.

### Testing and provision

* Create a folder and put the `server.ovpn` and `client.template` there.
* Run the command below to provision a new OpenVPN server.

```
docker run \
   --rm -it \
   --net host \
   --name openvpn-server \
   --env EASYRSA_REQ_CN="my.vpn.example.com" \
   --env EASYRSA_BATCH="yes" \
   --cap-add=NET_ADMIN \
   --device=/dev/net/tun \
   --volume <path-to-vpn-folder>:/opt/openvpn:rw \
   fialakarel/openvpn-server:latest
```

### Daemonize

Run the already configured OpenVPN server in the backgroud.

```
docker run \
   --detach \
   --restart always \
   --net host \
   --name openvpn-server \
   --cap-add=NET_ADMIN \
   --device=/dev/net/tun \
   --volume <vpn-storage>:/opt/openvpn:rw \
   fialakarel/openvpn-server:latest
```

## Managing clients


### Create users

```
docker exec openvpn-server create-user <user>
```

* Certificates are stored under `<vpn-storage>/clients/<user>/`.
* File `<user>-bundle.ovpn` contains client configuration and all required certs and keys.


### Update CRL on server

* The default `crl.pem` validity is 10 years.
* The CRL file is regenerate on every start of OpenVPN server as well as on each certificate revocation.
 
```
docker exec openvpn-server update-crl
```

### Revoke certificate

* You *do not need* to restart OpenVPN after this.

```
docker exec openvpn-server revoke-certificate <user>
```

## Iptables and routes

Probably, you will need to masquerade (or routing) your VPN traffic.

```
# Modify and add this line to your /etc/rc.local
iptables -t nat -A POSTROUTING -s 192.168.111.0/24 ! -o tun0 -j MASQUERADE
```