#!/bin/bash

    # input file name
    # exclude list from file
    # use syn scan on port 80
    # no DNS resolution
    # source port is 55555
    # no retry after send
    # will to sacrifice some accuracy for speed

TODAY_SERVER=$(date +%y_%m_%d_server)
(sudo TODAY_SERVER=$TODAY_SERVER python -c '
from os import environ
import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)

from scapy.all import sniff
from scapy.all import IP, TCP

def store_pkg(pkg):
    if pkg.haslayer(IP) and pkg.haslayer(TCP):
        if pkg[IP].dst == "101.200.190.85" and pkg[TCP].dport == 55555:
            r.write(pkg[IP].src+"\n")

with open(environ["TODAY_SERVER"], "a") as r:
    sniff(store=0, iface="eth1", filter="dst host 101.200.190.85 and tcp dst port 55555", prn=store_pkg)
' &> /dev/null) &

sudo nmap -iL world_ip_list.txt --excludefile china_ip_list/china_ip_list.txt -PS -n -e eth1 --source-port 55555 --max-retries 0 -T insane &> /dev/null
head -2 test_file  | grep -o '[[:digit:]]\{,3\}\.[[:digit:]]\{,3\}\.[[:digit:]]\{,3\}\.[[:digit:]]\{,3\}'

# https://scans.io
