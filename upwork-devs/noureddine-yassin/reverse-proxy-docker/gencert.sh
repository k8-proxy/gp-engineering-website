#!/bin/bash
openssl genrsa -out server.key 2048
echo -e '\n\n\n\n\n' | openssl req -new -out - -key server.key -config openssl.cnf 2> /dev/null | openssl x509 -req -days 3650 -in - -signkey server.key -out server.crt -extensions v3_req -extfile openssl.cnf 2> /dev/null
echo -e '\n\n\n\n\n' |echo -e '\n\n\n\n\n' | openssl req -x509 -new -nodes -key server.key -sha256 -days 3650 -out server.ca -config openssl.cnf 
cat server.key server.crt > full.pem
