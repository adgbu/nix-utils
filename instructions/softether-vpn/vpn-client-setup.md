# Setup SoftEther VPN (client only)

https://www.softether.org


## Install client and server

The easiest way to install (at least on Linux) is to build from source. This will install __both the vpnclient and vpnserver__ programs. 
The make script will do everything automatically including copy files to the right locations and setting permissions. 
For some reason, if you download the pre-built binaries, you have to do that manually.

Install some software that is required.

    $ sudo apt install -y build-essential libncurses-dev libreadline-dev libcxxtools-dev libcrypto++-dev libssl-dev libz-dev

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


## Configure SoftEther VPN client

Before you start you need to have your connection information ready. You will need:

- Address to the VPN server (for example VpnName.softether.net)
- Make up a name for the connection (e.g. use the same VpnName).
- Name of the virtual hub.
- Your username and password.

Note:
As an alternative to running __vpncmd__ interactively, you can also control it with parameters which is useful for scripting. Example:

    $ vpncmd localhost /CLIENT /CMD <command> <arg1>

Below are all steps to configure a new client interactively. Subsitute names for your own as necessary.

Ensure that vpnclient is running, otherwise start it manually.

    $ sudo vpnclient start

```
$ sudo vpncmd
Select: 2 (Management of VPN Client)
Hostname: (localhost)
VPN Client> check

Every check should say: Pass.

VPN Client> RemoteEnable
VPN Client> NicCreate softeth
VPN Client> AccountCreate 
Name of VPN Connection: VpnName
Destination VPN Server: VpnName.softether.net:443
Destination Virtual Hub: VirtualHubName
Connecting User Name: Username
Used Virtual Network Adapter Name: softeth
VPN Client> AccountList
VPN Client> AccountPasswordSet VpnName
Password: ****
Confirm: ****
Specify standard or radius: standard
VPN Client> AccountStartupSet
Name of VPN Connection: VpnName
VPN Client> AccountConnect VpnName
VPN Client> AccountList
...
Status: Connected
...
VPN Client> exit
```

Check that you now have a network interface called "vpn_softeth". 
It will not have any IPv4 address, because we have not requested one yet.

    $ ifconfig

Manually request an address from the virtual DHCP server. 
Then check ifconfig again and you should have an IPv4 address.

    $ sudo dhclient -v vpn_softeth
    $ ifconfig vpn_softeth


## Autostart vpnclient

We will setup two systemd services to start a vpn client and dhcp client.
The unit files are already written and stored in this directory as 
'softeth-vpnclient.service' and 'softeth-dhclient.service'.

The proper target directory for the unit files is '/etc/systemd/system'.
Let systemd know that you have made changes to unit files.

    $ sudo systemctl daemon-reload

Start the service an check the status. Finally enable autostart.

    $ sudo systemctl start softeth-vpnclient.service
    $ sudo systemctl status softeth-vpnclient.service
    $ sudo systemctl enable softeth-vpnclient.service

Repeat the same procedure for 'softeth-dhclient.service'.
Done. Reboot.
