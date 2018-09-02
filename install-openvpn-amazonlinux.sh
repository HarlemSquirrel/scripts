#! /bin/sh

# ---------------------------------
# Install OpenVPN in Amazon Linux
# 2017 July 21
# ---------------------------------

sudo yum update
sudo yum --enablerepo=epel install easy-rsa openvpn ufw

# copy template and set server config settings
cp /usr/share/doc/openvpn-2.4.3/sample/sample-config-files/server.conf /etc/openvpn/
vim /etc/openvpn/server.conf


# Enable packet forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
vim /etc/sysctl.conf # set net.ipv4.ip_forward=1

# Set ufw rules
sudo ufw allow ssh
sudo ufw allow 1194/udp
sudo vim /etc/default/ufw # set DEFAULT_FORWARD_POLICY="ACCEPT"
vim /etc/ufw/before.rules
# Add the following to the top of the file
<<RULES
#
# rules.before
#
# Rules that should be run before the ufw command line added rules. Custom
# rules should be added to one of these chains:
#   ufw-before-input
#   ufw-before-output
#   ufw-before-forward
#

# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to eth0
-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE
COMMIT
# END OPENVPN RULES
RULES

# Copy easy-rsa scripts and edit vars
sudo cp -r /usr/share/easy-rsa/2.0/ /etc/openvpn
vim /etc/openvpn/easy-rsa/vars

# Generate DiffieHellman parameters
openssl dhparam -out /etc/openvpn/dh2048.pem 2048

# Generate keys
cd /etc/openvpn/easy-rsa
sudo ./clean-all
sudo ./build-ca
sudo ./build-key-server server
sudo openvpn --genkey --secret ta.key
cp /etc/openvpn/easy-rsa/keys/{server.crt,server.key,ca.crt} /etc/openvpn

# Change the owner of keys and certs
sudo chown nobody ca.crt server.crt server.key ta.key

# Start the server
sudo service openvpn start

# Build client keys
key_name="kevin-phone"
./build-key $key_name
