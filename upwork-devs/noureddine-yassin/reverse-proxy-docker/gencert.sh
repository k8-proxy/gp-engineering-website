#!/bin/bash
echo -e '\n\n\n\n\n' | openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout server.key -out server.crt -config openssl.cnf 2> /dev/null
cat server.key server.crt > full.pem
