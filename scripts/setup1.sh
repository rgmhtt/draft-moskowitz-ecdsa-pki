
# edit directory here, or override
export cadir=${cadir-/root/ca}
export rootca=${cadir}/root
export cfgdir=${cfgdir-$cadir}
export intdir=${cadir}/intermediate
export int1ardir=${cadir}/inter_1ar
export format=pem
export default_crl_days=65

mkdir -p $cadir/certs
mkdir -p $rootca
(cd $rootca
mkdir -p certs crl csr newcerts private
chmod 700 private
touch index.txt index.txt.attr
if [ ! -f serial ]; then echo 00 >serial; fi
)

sn=8

# edit these to suit
countryName="/C=US"
stateOrProvinceName="/ST=MI"
localityName="/L=Oak Park"
organizationName="/O=HTT Consulting"
#organizationalUnitName="/OU="
organizationalUnitName=
commonName="/CN=Root CA"
DN=$countryName$stateOrProvinceName$localityName
DN=$DN$organizationName$organizationalUnitName$commonName

echo $DN
export subjectAltName=email:postmaster@htt-consult.com

export default_crl_days=2048
