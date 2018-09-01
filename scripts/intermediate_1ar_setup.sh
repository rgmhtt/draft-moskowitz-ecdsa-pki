export dir=$cadir/8021ARintermediate
mkdir $dir
cd $dir
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
sn=8 # hex 8 is minimum, 19 is maximum
echo 1000 > $dir/crlnumber

# cd $dir
export crlDP=
# For CRL support use uncomment these:
#crl=8021ARintermediate.crl.pem
#crlurl=www.htt-consult.com/pki/$crl
#export crlDP="URI:http://$crlurl"
export default_crl_days=30
export ocspIAI=
# For OCSP support use uncomment these:
#ocspurl=ocsp.htt-consult.com
#export ocspIAI="OCSP;URI:http://$ocspurl"

countryName="/C=US"
stateOrProvinceName="/ST=MI"
localityName="/L=Oak Park"
organizationName="/O=HTT Consulting"
organizationalUnitName="/OU=Devices"
#organizationalUnitName=
commonName="/CN=802.1AR CA"
DN=$countryName$stateOrProvinceName$localityName$organizationName
DN=$DN$organizationalUnitName$commonName
echo $DN
export subjectAltName=email:postmaster@htt-consult.com
echo $subjectAltName
