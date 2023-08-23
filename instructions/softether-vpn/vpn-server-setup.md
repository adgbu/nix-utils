# Setup SoftEther VPN (server only)

https://www.softether.org


## Install client and server

The easiest way to install (at least on Linux) is to build from source. This will install __both the vpnclient and vpnserver__ programs. The make script will do everything automatically including copy files to the right locations and setting permissions. For some reason, if you download the pre-built binaries, you have to do that manually.

Install some software that is necessary.

    $ sudo apt install -y build-essential build-essential libncurses-dev libreadline-dev libcxxtools-dev libcrypto++-dev libssl-dev libz-dev

Download and compile the code.

    $ git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
    $ cd SoftEtherVPN_Stable
    $ cat BUILD_UNIX.TXT
    $ ./configure
    $ make

Check that there were no build errors. Then install.

    $ sudo make install
    $ which vpncmd
    /usr/bin/vpncmd


## Check vpnserver

Run ```vpncmd``` to check that everything is OK __before__ you continue to set up a server.

    $ sudo vpncmd
    Select: 3 "VPN Tools"
    VPN Tools> check

Everything should say: Pass.

    VPN Tools> exit


## Autostart vpnserver

We will setup a systemd service to start vpnserver automatically.
The proper target directory for the unit file is '/etc/systemd/system'.

Create a symbolic link in your home directory, which will help you find the systemd unit file in the future and serve as documentation.

    $ cd
    $ ln -s /etc/systemd/system/softeth-vpnserver.service .

Edit the unit file and paste the content below.

    $ sudo nano softeth-vpnserver.service

```
[Unit]
Description=SoftEther VPN Server
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/vpnserver start
ExecStop=/usr/bin/vpnserver stop

[Install]
WantedBy=multi-user.target
```

Check that it's working and enable it to start automatically at boot. 
Tip: Tab completion works on known services.

    $ sudo systemctl daemon-reload
    $ sudo systemctl start softeth-vpnserver.service
    $ sudo systemctl status softeth-vpnserver.service
    $ sudo systemctl enable softeth-vpnserver.service


## Configure vpnserver

Ensure vpnserver is running, either as a service or start it manually like this.

    $ sudo vpnserver start

Set the vpnserver administrator password.

    $ sudo vpncmd
    Select: 1 "Management of VPN Server"
    Hostname: (empty)
    Specify Virtual Hub Name: (empty)
    VPN Server> ServerPasswordSet
    Password: ****
    Confirm input: ****
    The command completed successfully.
    VPN Server> exit

The rest of configuration can be done with __SoftEther VPN Server Manager__, which is a GUI application available for Windows *and now also macOS*. 
Connect from VPN Server Manager using IP address/hostname and password over HTTPS (443). 
SoftEther VPN Server is capable of handling NAT traversal. There is no need to open up any ports. 


## Server configuration check list

Quick start list for __SoftEther VPN Server Manager__.

- Add a connection setting to your VPN server. Connect.
- Open Encryption and Network and select Encryption Algorithm. 
AES256-SHA in recommended.
- Open Local Bridge Setting and clear any local bridges.
- Open Dynamic DNS Setting and select a DNS Hostname you can remember.
- Open IPsec/L2TP Setting and enable L2TP Server (if you need this).
Remember to forward ports UDP 500 and 4500 for L2TP connections.
- Create a virtual hub, then open Manage Virtual Hub. 
- Open Manage Users and create some users. Password Authentication is simplest.
- Configure SecureNAT for split tunneling as described below.


## Split tunnelling server configuration

Split tunneling means that not all network traffic will go through the VPN. The clients will still access the Internet directly. They will only send packets to the VPN when their destination address is on the VPN.

### Remove local bridges
First remove any Local Bridges. This is important.
On the __Manage VPN Server__ page open __Local Bridge Settings__. Clear any Local Bridge definitions.

### Configure Virtual DHCP server
Go to __Manage Virtual Hub__ > __Virtual NAT & Virtual DHCP Server (SecureNAT)__ 
Select  __Enable SecureNAT__.
Open __Secure NAT Configuration__.
Clear the __Default Gateway Address__ field.
Set the adress settings as you like while you are here. 
Open __Edit the static routing table to push__.
Type in the route like the example. Change it to match your subnet addresses e.g.:

    192.168.30.0/255.255.255.0/192.168.30.1

OK


## IPSec L2TP server config

It is possible to connect to the VPN server over L2TP. This is the easiest way to connect form iPhone, Android and also possible from Windows and macOS without installing any additional software.

On the __Manage VPN Server__ page open __IPSec / L2TP Setting__.
Check __Enable L2TP Server Function__ (L2TP over IPsec)
Set an __IPsed Pre-Shared Key__. Each client will need this "secret" in addition to their own username and password in order to connect.

Incoming traffic on ports __UDP 500 and 4500__ must be able to reach the VPN server. I have verified that this is required for L2TP connection.
