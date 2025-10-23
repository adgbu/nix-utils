#!/usr/bin/env python

# Requires an environmant with Python 3 and the tabulate dependency.

import subprocess
import re
from tabulate import tabulate

def run_nmap(subnet):
    result = subprocess.run(['sudo', 'nmap', '-sn', subnet], stdout=subprocess.PIPE)
    return result.stdout.decode()

def parse_nmap_output(output):
    ip_regex = re.compile(r'Nmap scan report for (.+) \((.+)\)|Nmap scan report for (.+)')
    mac_regex = re.compile(r'MAC Address: (.+) \((.+)\)')
    rtt_regex = re.compile(r'Host is up \((.+) latency\)')

    hosts = []
    current_host = {}

    for line in output.splitlines():
        ip_match = ip_regex.match(line)
        if ip_match:
            if current_host:
                hosts.append(current_host)
                current_host = {}
            if ip_match.group(1):
                current_host['Hostname'] = ip_match.group(1)
                current_host['IP Address'] = ip_match.group(2)
            else:
                current_host['Hostname'] = ''
                current_host['IP Address'] = ip_match.group(3)
            continue

        rtt_match = rtt_regex.search(line)
        if rtt_match:
            current_host['RTT'] = rtt_match.group(1)
            continue

        mac_match = mac_regex.match(line)
        if mac_match:
            current_host['MAC Address'] = mac_match.group(1)
            current_host['Manufacturer'] = mac_match.group(2)
            current_host['Status'] = 'Up'
            continue

    if current_host:
        hosts.append(current_host)

    return hosts

def display_hosts(hosts):
    headers = ["Hostname", "IP Address", "MAC Address", "Manufacturer", "RTT", "Status"]
    print(tabulate(hosts, headers=headers, tablefmt="pretty"))

def main():
    subnet = input("Enter the subnet (e.g., 192.168.1.0/24): ")
    output = run_nmap(subnet)
    hosts = parse_nmap_output(output)
    display_hosts(hosts)

if __name__ == "__main__":
    main()
