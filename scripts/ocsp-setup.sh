
# Select which Intermediate level
intermediate=intermediate
#intermediate=8021ARintermediate
# Optionally, password encrypt key pair
encryptkey=
#encryptkey=-aes256

# Create the key pair in Intermediate level $intermediate
cd $dir
openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1\
    $encryptkey -pkeyopt ec_param_enc:named_curve\
    -out $dir/private/$ocspurl.key.$format
chmod 400 $dir/private/$ocspurl.$format
openssl pkey -in $dir/private/$ocspurl.key.$format -text -noout

# Create CSR
commonName=
DN=$countryName$stateOrProvinceName$localityName
DN=$DN$organizationName$organizationalUnitName$commonName
echo $DN
emailaddr=postmaster@htt-consult.com
export subjectAltName="DNS:$ocspurl, email:$emailaddr"
echo $subjectAltName
openssl req -config $dir/openssl-$intermediate.cnf\
    -key $dir/private/$ocspurl.key.$format \
    -subj "$DN" -new -sha256 -out $dir/csr/$ocspurl.csr.$format

openssl req -text -noout -verify -in $dir/csr/$ocspurl.csr.$format

# Create Certificate

openssl rand -hex $sn > $dir/serial # hex 8 is minimum, 19 is maximum
# Note 'openssl ca' does not support DER format
openssl ca -config $dir/openssl-$intermediate.cnf -days 375\
    -extensions ocsp -notext -md sha256 \
    -in $dir/csr/$ocspurl.csr.$format\
    -out $dir/certs/$ocspurl.cert.$format
chmod 444 $dir/certs/$ocspurl.cert.$format

openssl verify -CAfile $dir/certs/ca-chain.cert.$format\
     $dir/certs/$ocspurl.cert.$format
openssl x509 -noout -text -in $dir/certs/$ocspurl.cert.$format

