#!/bin/sh
# this generates a CA for a manufacturer which is simply unknown.

set -e
mkdir -p testthing
cd testthing

echo PASSWORD is '"badguy"'

#
PATH=../ecdsa-pki-1/scripts:$PATH export PATH
. ./setup1.sh

figlet GENERATING ROOT CERTIFICATE
. rootcert.sh
echo

. ./intermediate_setup.sh
figlet GENERATING INTERMEDIATE CERTIFICATE
. intermediate_cert.sh
echo

commonName=""
UserID="/UID=newdevice"
DN=$countryName$stateOrProvinceName$localityName
DN=$DN$organizationName$organizationalUnitName$commonName$UserID
echo $DN
clientemail=newdevice@malicious.example.com
figlet GENERATING END ENTITY CERTIFICATE
set -x
. end-client.sh
echo

echo PUBLIC KEY for fixture:
openssl x509 -in certs/intermediate.cert.pem -pubkey -nocert -outform der | base64
