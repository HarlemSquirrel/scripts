#!/usr/bin/env python3

## hostname_lookup_from_csv.py
#
# Lookup hostnames from IP addresses.
#
# Read from a source CSV file looking at the first column for IP addresses,
# attempt a hostname lookup, then save the result to a new CSV file.
#

import csv
import re
import socket
import sys

try:
    source_file = sys.argv[1]
    target_file = sys.argv[2]
except IndexError as e:
    print("Missing source and/or target files!")
    print("  %s source.csv target.csv" % sys.argv[0])

print("\nLooking up IP addresses in %s and saving to %s\n" % (source_file, target_file))

hostnames = {}

with open(source_file, newline='') as source_file_csv:
    csv_reader = csv.reader(source_file_csv, delimiter=',', quotechar='|')
    with open(target_file, 'w', newline='') as target_file_csv:
        csv_writer = csv.writer(target_file_csv, delimiter=',',
                                quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for row in csv_reader:
            ip = row[0]
            # Ignore rows that do not start with an IP address
            if re.match('\d+\.\d+\.\d+\.\d+', ip):
                try:
                    # First check if we've already looked up this IP
                    if not ip in hostnames:
                        hostnames[ip] = socket.gethostbyaddr(ip)[0]
                except (socket.gaierror, socket.herror) as e:
                    hostnames[ip] = 'NOT FOUND'

                csv_writer.writerow([ip, hostnames[ip]])
                print("%s - %s" % (ip, hostnames[ip]))

print("Done! :)")
