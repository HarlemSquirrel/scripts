#!/bin/sh

sudo apt update

sudo apt install git python-dev python-spidev vim

mkdir code
cd code
git clone https://github.com/jpbarraca/pynrf24.git
