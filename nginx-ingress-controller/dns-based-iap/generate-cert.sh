#!/bin/bash
FQDN=your.domain.test
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt -subj "/CN=$FQDN"
