#!/usr/bin/env python3

"""
Download podcasts from an XML RSS feed.
"""

import argparse
import os
import urllib.request
import xml.etree.ElementTree as ET

parser = argparse.ArgumentParser(description='Download podcasts from an XML RSS feed.')
parser.add_argument('feed_url', type=str, help='the RSS feed URL')
parser.add_argument('directory', type=str, help='local directory to save to')
args = parser.parse_args()

# Podbean seems to deny requests without this user-agen header.
RSS_FEED_HEADERS = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
}

print("\nRetrieving RSS feed file...")

# Retrieve the latest RSS feed XML file.
req = urllib.request.Request(args.feed_url, headers=RSS_FEED_HEADERS)
xml_string = urllib.request.urlopen(req).read().decode("utf-8")
root = ET.fromstring(xml_string)

# Find the number of posts so we can keep track of the progress.
num_posts = len(root.find('channel').findall('item'))
num_processed = 0

print(f"Downloading {num_posts} to {args.directory}...")

for item in root.find('channel').findall('item'):
    num_processed += 1
    mp3_url = item.find('enclosure').get('url')
    mp3_filename = mp3_url.split('/')[-1]
    download_path = os.path.join(args.directory, mp3_filename)

    # Check if we aleady have a file with this name downloaded.
    if os.path.exists(download_path):
        print(f"{num_processed}/{num_posts} {download_path} already exists")
        continue

    print(f"{num_processed}/{num_posts} Downloading {mp3_url} to {args.directory}/")
    try:
        info = urllib.request.urlretrieve(mp3_url, download_path)
    except urllib.error.HTTPError as e:
        print(f"  Failed to download! {e}")
