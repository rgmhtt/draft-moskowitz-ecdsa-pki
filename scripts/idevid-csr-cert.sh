
DevID=Wt1234
countryName=
stateOrProvinceName=
localityName=
organizationName="/O=HTT Consulting"
organizationalUnitName="/OU=Devices"
commonName=
serialNumber="/serialNumber=$DevID"
DN=$countryName$stateOrProvinceName$localityName
DN=$DN$organizationName$organizationalUnitName$commonName
DN=$DN$serialNumber
echo $DN

# hwType is OID for HTT Consulting, devices, sensor widgets
export hwType=1.3.6.1.4.1.6715.10.1
export hwSerialNum=01020304 # Some hex
export subjectAltName="otherName:1.3.6.1.5.5.7.8.4;SEQ:hmodname"
echo  $hwType - $hwSerialNum

openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1\
    -pkeyopt ec_param_enc:named_curve\
    -out $dir/private/$DevID.key.$format
chmod 400 $dir/private/$DevID.key.$format
openssl pkey -in $dir/private/$DevID.key.$format -text -noout
openssl req -config $dir/openssl-8021ARintermediate.cnf\
    -key $dir/private/$DevID.key.$format \
    -subj "$DN" -new -sha256 -out $dir/csr/$DevID.csr.$format

openssl req -text -noout -verify\
    -in $dir/csr/$DevID.csr.$format
openssl asn1parse -i -in $dir/csr/$DevID.csr.pem
# offset of start of hardwareModuleName and use that in place of 189
openssl asn1parse -i -strparse 189 -in $dir/csr/$DevID.csr.pem

openssl rand -hex $sn > $dir/serial # hex 8 is minimum, 19 is maximum
# Note 'openssl ca' does not support DER format
openssl ca -config $dir/openssl-8021ARintermediate.cnf -days 375\
    -extensions 8021ar_idevid -notext -md sha256 \
    -in $dir/csr/$DevID.csr.$format\
    -out $dir/certs/$DevID.cert.$format
chmod 444 $dir/certs/$DevID.cert.$format

openssl verify -CAfile $dir/certs/ca-chain.cert.$format\
     $dir/certs/$DevID.cert.$format
openssl x509 -noout -text -in $dir/certs/$DevID.cert.$format
openssl asn1parse -i -in $dir/certs/$DevID.cert.pem

# offset of start of hardwareModuleName and use that in place of 493
openssl asn1parse -i -strparse 493 -in $dir/certs/$DevID.cert.pem

