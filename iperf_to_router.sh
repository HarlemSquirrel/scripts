#!/bin/bash

printf "Start iperf on the router.\n"

read -p "  What is the port number? " port_number;

iperf3 -c 192.168.1.1 --port $port_number

read -p "  What is the port number now for reverse test? " port_number_reverse;

iperf3 -c 192.168.1.1 --port $port_number_reverse --reverse
