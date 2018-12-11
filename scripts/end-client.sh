export subjectAltName="email:$clientemail"
echo $subjectAltName

if [ ! -f $dir/private/$clientemail.key.$format ]; then
openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1\
    -pkeyopt ec_param_enc:named_curve\
    -out $dir/private/$clientemail.key.$format
chmod 400 $dir/private/$clientemail.$format
openssl pkey -in $dir/private/$clientemail.key.$format -text -noout
fi

openssl req -config $dir/openssl-intermediate.cnf\
    -key $dir/private/$clientemail.key.$format \
    -subj "$DN" -new -sha256 -out $dir/csr/$clientemail.csr.$format

openssl req -text -noout -verify\
    -in $dir/csr/$clientemail.csr.$format

openssl rand -hex $sn > $dir/serial # hex 8 is minimum, 19 is maximum
# Note 'openssl ca' does not support DER format
openssl ca -config $dir/openssl-intermediate.cnf -days 375\
    -extensions usr_cert -notext -md sha256 \
    -in $dir/csr/$clientemail.csr.$format\
    -out $dir/certs/$clientemail.cert.$format
chmod 444 $dir/certs/$clientemail.cert.$format

openssl verify -CAfile $dir/certs/ca-chain.cert.$format\
     $dir/certs/$clientemail.cert.$format
openssl x509 -noout -text -in $dir/certs/$clientemail.cert.$format
