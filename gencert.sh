#!/bin/bash
echo -e '\n\n\n\n\n' | openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout ca-key.pem -out ca.pem -config openssl-ca.cnf	2> /dev/null
openssl genrsa -out server.key 2048 2> /dev/null
echo -e '\n\n\n\n\n' | openssl req -new -sha256 -key server.key -out server.csr -config openssl.cnf -extensions 'v3_req'			2> /dev/null
openssl x509 -req -days 3650 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server.crt -sha256 -extfile openssl.cnf -extensions v3_req 2> /dev/null
cat server.key server.crt > full.pem
