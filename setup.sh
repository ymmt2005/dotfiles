#!/bin/sh

sudo apt-get update
sudo apt-get -y --no-install-recommends make
make setup
make