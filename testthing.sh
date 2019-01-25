#!/bin/sh
# this generates a CA for a manufacturer which is simply unknown.

set -e

cd ..
mkdir -p testthing
cd testthing
export cadir=`pwd`
for setup in setup1.sh intermediate_setup.sh
do
    [ -f ./$setup ] || cp ../draft-moskowitz-ecdsa-pki-1/scripts/$setup .
done
for cfg in openssl-8021ARintermediate.cnf  openssl-intermediate.cnf  openssl-root.cnf
do
    [ -f ./$cfg ] || cp ../draft-moskowitz-ecdsa-pki-1/configs/$cfg .
done

echo PASSWORD is '"test1234"'
export pass="-pass pass:test1234"
export passin="-passin pass:test1234"

#
PATH=../draft-moskowitz-ecdsa-pki-1/scripts:$PATH export PATH
. ./setup1.sh

echo GENERATING ROOT CERTIFICATE
. rootcert.sh
echo

. ./intermediate_setup.sh
echo GENERATING INTERMEDIATE CERTIFICATE
. intermediate_cert.sh
echo

commonName=""
UserID="/UID=newdevice"
DN=$countryName$stateOrProvinceName$localityName
DN=$DN$organizationName$organizationalUnitName$commonName$UserID
echo $DN
clientemail=newdevice@malicious.example.com
echo GENERATING END ENTITY CERTIFICATE
. end-client.sh
echo

echo PUBLIC KEY for fixture:
openssl x509 -in certs/intermediate.cert.pem -pubkey -nocert -outform der | base64
