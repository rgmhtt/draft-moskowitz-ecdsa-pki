# draft-moskowitz-ecdsa-pki
This memo provides a guide for building a PKI (Public Key
Infrastructure) using openSSL.  All certificates in this guide
are ECDSA, P-256, with SHA256 certificates.  Along with common
End Entity certificates, this guide provides instructions for
creating IEEE 802.1AR iDevID Secure Device certificates.

# using the scripts

Edit the scripts/*_setup.sh scripts to set the variables
as desired.

There is a root CA, and two intermediate CAs.  The scripts
are designed to be invoked from a master scripts that can
be part of a regression testing package.  A common need is to
be able to create both legitimate and illigitimate CAs and
certificates that may need to attempt to overclaim certain things in order to
test code that verifies the claims.

The setup1.sh script should have the following variables setup:

    cadir=    the top directory for all work.
    rootdir=  the directory for the root CA ($cadir/root)
    intdir=   the directory for the intermediate CA ($cadir/intermediate)
    int1ardir=the directory for the 802.1AR intermediate CA ($cadir/802ar)

All configuration files are stored in $cadir.

A good methology is to incorporate this repo as a git submodule into a larger
project.  Copy the scripts/*setup.sh scripts into a new directory, to which
$cadir is pointed.   A driver script sources the setup files with
./foo_setup.sh, and then calls different scripts like "rootcert.sh" with .

Also see [[TESTING]] for how these scripts are being tested.


