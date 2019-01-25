# Create passworded keypair file

if [ ! -f $dir/private/intermediate.key.$format ]; then
openssl genpkey -aes256 -algorithm ec\
    -pkeyopt ec_paramgen_curve:prime256v1 \
    -outform $format -pkeyopt ec_param_enc:named_curve\
    -out $dir/private/intermediate.key.$format
chmod 400 $dir/private/intermediate.key.$format
openssl pkey -inform $format\
        -in $dir/private/intermediate.key.$format -text -noout
fi

# Create the CSR

openssl req -config $cadir/openssl-root.cnf\
    -key $dir/private/intermediate.key.$format \
    -keyform $format -outform $format -subj "$DN" -new -sha256\
    -out $dir/csr/intermediate.csr.$format
openssl req -text -noout -verify -inform $format\
    -in $dir/csr/intermediate.csr.$format


# Create Intermediate Certificate file

openssl rand -hex $sn > $dir/serial # hex 8 is minimum, 19 is maximum

if [ ! -f $dir/certs/intermediate.cert.pem ]; then
    # Note 'openssl ca' does not support DER format
    openssl ca -config $cadir/openssl-root.cnf -days 3650\
            -extensions v3_intermediate_ca -notext -md sha256 \
            -in $dir/csr/intermediate.csr.$format\
            -out $dir/certs/intermediate.cert.pem
    chmod 444 $dir/certs/intermediate.cert.$format
    rm -f $dir/certs/ca-chain.cert.$format
fi


openssl verify -CAfile $cadir/certs/ca.cert.$format\
     $dir/certs/intermediate.cert.$format

openssl x509 -noout -text -in $dir/certs/intermediate.cert.$format

# Create the certificate chain file

if [ ! -f $dir/certs/ca-chain.cert.$format ]; then
    cat $dir/certs/intermediate.cert.$format\
        $cadir/certs/ca.cert.$format > $dir/certs/ca-chain.cert.$format
    chmod 444 $dir/certs/ca-chain.cert.$format
fi
