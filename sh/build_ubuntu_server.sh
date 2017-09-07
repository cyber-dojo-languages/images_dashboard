#!/bin/bash

# Works on Ubuntu 16.04
curl -sSL https://get.docker.com/ | sh
curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.15.0/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose
docker pull cyberdojo/question-book:1.0

echo
echo 'sudo ./up.sh'
echo