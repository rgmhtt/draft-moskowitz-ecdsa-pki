export subjectAltName="email:$clientemail"
echo $subjectAltName

if [ ! -f $intdir/private/$clientemail.key.$format ]; then
    openssl genpkey $pass -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1\
            -pkeyopt ec_param_enc:named_curve\
            -out $intdir/private/$clientemail.key.$format
    chmod 400 $intdir/private/$clientemail.key.$format
    openssl pkey $passin -in $intdir/private/$clientemail.key.$format -text -noout
fi

openssl req -config $cfgdir/openssl-intermediate.cnf $passin \
    -key $intdir/private/$clientemail.key.$format \
    -subj "$DN" -new -sha256 -out $intdir/csr/$clientemail.csr.$format

openssl req -text -noout -verify\
    -in $intdir/csr/$clientemail.csr.$format

openssl rand -hex $sn > $intdir/serial # hex 8 is minimum, 19 is maximum
# Note 'openssl ca' does not support DER format
openssl ca -config $cfgdir/openssl-intermediate.cnf -days 375\
    -extensions usr_cert -notext -md sha256 $passin \
    -in   $intdir/csr/$clientemail.csr.$format -batch\
    -out  $cadir/certs/$clientemail.cert.$format
chmod 444 $cadir/certs/$clientemail.cert.$format

openssl verify -CAfile $cadir/certs/ca-chain.cert.$format\
     $cadir/certs/$clientemail.cert.$format
openssl x509 -noout -text -in $cadir/certs/$clientemail.cert.$format
