
commonName=
DN=$countryName$stateOrProvinceName$localityName
DN=$DN$organizationName$organizationalUnitName$commonName
echo $DN
serverfqdn=www.example.com
emailaddr=postmaster@htt-consult.com
export subjectAltName="DNS:$serverfqdn, email:$emailaddr"
echo $subjectAltName
openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1\
    -pkeyopt ec_param_enc:named_curve\
    -out $dir/private/$serverfqdn.key.$format
chmod 400 $dir/private/$serverfqdn.$format
openssl pkey -in $dir/private/$serverfqdn.key.$format -text -noout
openssl req -config $dir/openssl-intermediate.cnf\
    -key $dir/private/$serverfqdn.key.$format \
    -subj "$DN" -new -sha256 -out $dir/csr/$serverfqdn.csr.$format

openssl req -text -noout -verify -in $dir/csr/$serverfqdn.csr.$format

openssl rand -hex $sn > $dir/serial # hex 8 is minimum, 19 is maximum
# Note 'openssl ca' does not support DER format
openssl ca -config $dir/openssl-intermediate.cnf -days 375\
    -extensions server_cert -notext -md sha256 \
    -in $dir/csr/$serverfqdn.csr.$format\
    -out $dir/certs/$serverfqdn.cert.$format
chmod 444 $dir/certs/$serverfqdn.cert.$format

openssl verify -CAfile $dir/certs/ca-chain.cert.$format\
     $dir/certs/$serverfqdn.cert.$format
openssl x509 -noout -text -in $dir/certs/$serverfqdn.cert.$format

