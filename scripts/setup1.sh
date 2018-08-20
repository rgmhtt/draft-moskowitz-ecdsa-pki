   export dir=/root/ca
   export cadir=/root/ca
   export format=pem
   mkdir $dir
   cd $dir
   mkdir certs crl csr newcerts private
   chmod 700 private
   touch index.txt
   touch serial
   sn=8

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
