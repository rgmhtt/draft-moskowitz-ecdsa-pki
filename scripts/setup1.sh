# edit directory here
export dir=/root/ca
export cadir=/root/ca
export cfgdir=../configs
export format=pem
export default_crl_days=65

mkdir -p $dir
#cd $dir
mkdir -p $dir/certs $dir/crl $dir/csr $dir/newcerts $dir/private
chmod 700 $dir/private
touch $dir/index.txt
touch $dir/serial
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
