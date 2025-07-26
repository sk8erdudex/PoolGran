#!/bin/bash

# This whole script is running as root, but the SSH command below is executed as 'pool'
sudo -u pool ssh -p 1995 steamuser@jariel.ddns.net 'date > /tmp/connected_from_nat_$(date +%s)'
