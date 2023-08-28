## Autostart with systemd

Put your custom unit files in 

    /etc/systemd/system

More unit files are located in

    /lib/systemd/system/

To make it easier to remember and find the unit file, 
I create a symbolic links in my home directory.

    $ cd
    $ ln -s /etc/systemd/system/example.service .

Edit the unit file to do what you want. You need to understand different options for ```Type```.
See docs for more details.

    $ sudo nano example.service

*Example systemd unit file.*
```
[Unit]
Description=Service to log weather data.
Wants=network.target

[Service]
Type=exec
User=pi
Group=pi
ExecStart=/home/pi/weather-logger
#KillSignal=(default sigterm)
#ExecStop=(custom stop command)
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target

# Documentation 
# $ man systemd.unit
# https://www.freedesktop.org/software/systemd/man/systemd.unit.html#
```

By default services of Type=exec are stopped with a SIGTERM signal.
It is possible set KillSignal or ExecStop, to stop the service differently.
Best practise is to write your application to exit gracefully on SIGTERM.


Make systemd aware of your changes.

    $ sudo systemctl daemon-reload

Check the status of a service.

    $ sudo systemctl status example.service

Manually start/stop a service.

    $ sudo systemctl start example.service
    $ sudo systemctl stop example.service

Enable or disable automatic start of service (at boot).

    $ sudo systemctl enable example.service
    $ sudo systemctl disable example.service

You can monitor the output from a running service at any time.

    $ journalctl -f -u example


## Correct time without RTC

On a system without an RTC (like Raspberry Pi) you may want to wait to 
start services until we have established the current time using NTP.

First of all there is a service for this in recent versions of systemd.

    $ sudo systemctl enable systemd-time-wait-sync

Then make sure any dependent service waits until time is synchronized.

    After=time-sync.target


## Services that require Internet connection

Some services may depend on a network interface being ready or even an Internet connection. 
Both of these can be declared as dependencies for the service. I am not sure which key is
the correct to use: ```Wants``` / ```After``` / ```Requires```, but the following works.

Set ```network-online.target``` as a dependency to postpone the start of the service
until we are connected to the Internet.

    Wants=network-online.target
    After=network-online.target

Set ```network.target``` as a dependency if the service only requires a connection
to the local network.

    Wants=network.target
    After=network.target
