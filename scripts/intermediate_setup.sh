
export intdir=${intdir-$cadir/intermediate}
mkdir -p $intdir

(
cd $intdir
mkdir -p certs crl csr newcerts private
chmod 700 private
touch index.txt index.txt.attr
if [ ! -f serial ]; then echo 00 >serial; fi
)

sn=8 # hex 8 is minimum, 19 is maximum
echo 1000 > $intdir/crlnumber

# cd $dir
export crlDP=
# For CRL support use uncomment these:
#crl=intermediate.crl.pem
#crlurl=www.htt-consult.com/pki/$crl
#export crlDP="URI:http://$crlurl"
export default_crl_days=30
export ocspIAI=
# For OCSP support use uncomment these:
#ocspurl=ocsp.htt-consult.com
#export ocspIAI="OCSP;URI:http://$ocspurl"

commonName="/CN=Signing CA"
DN=$countryName$stateOrProvinceName$localityName$organizationName
DN=$DN$organizationalUnitName$commonName
echo $DN

