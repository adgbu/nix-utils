## Create a VPN connection

We will setup a connection from Windows using L2TP over IPsec. We will user a (secret) pre-shared key, username and password for authentication.

- Open Windows Settings > Network & Internet > VPN
- Click "Add a VPN connection"
- VPN Provider: Windows (built-in)
- VPN type: L2TP/IPsec with pre-shared key
- Type of sign-in info: Username and password
- Assign a "Connection name"
- Fill in the Server name, Pre-shared key (secret), Username and Password.
- Save 


## Split tunneling

Split tunneling means that the VPN-conection is used __only for traffic with a destination on the VPN network__. The VPN connection is __not used for all traffic__ to the Internet. This is useful to setup a virtual LAN where the hosts are not in the same physical location. On the other hand if you want to tunnel all your traffic to the Internet then spilt tunneling is not for that.

On Windows clients there is an extra step to setup split tunneling.

- Open Control Panel > Network and Internet > Network Connections
In Windows 10 you can also get here through Window's Settings
Windows Settings > Network & Internet > VPN > "Change adapter options"
- Right click the VPN connection and select Properties.
- Go to the tab Networking
- Select "Internet Protocol Version 4 (TCP/IPv4)" and click the Properties button. 
  + Click the Advanced... button.
  + Go to the tab IP Settings tab.
  + Uncheck "Use default gateway on remote network".
  + Click OK, OK.
- Select "Internet Protocol Version 6 (TCP/IPv6), click the Properties button and repeat the same 4 steps.
- Click OK
