# Create passworded keypair file

if [ ! -f $intdir/private/intermediate.key.$format ]; then
    echo GENERATING intermediate KEY
    openssl genpkey $pass -aes256 -algorithm ec \
            -pkeyopt ec_paramgen_curve:prime256v1 \
            -outform $format -pkeyopt ec_param_enc:named_curve\
            -out $intdir/private/intermediate.key.$format
    chmod 400 $intdir/private/intermediate.key.$format
    openssl pkey $passin -inform $format\
            -in $intdir/private/intermediate.key.$format -text -noout
fi

# Create the CSR

echo GENERATING and SIGNING REQ intermediate
openssl req -config $cfgdir/openssl-root.cnf $passin \
    -key $intdir/private/intermediate.key.$format -batch \
    -keyform $format -outform $format -subj "$DN" -new -sha256\
    -out $intdir/csr/intermediate.csr.$format
openssl req -text -noout -verify -inform $format\
    -in $intdir/csr/intermediate.csr.$format


# Create Intermediate Certificate file

openssl rand -hex $sn > $intdir/serial # hex 8 is minimum, 19 is maximum

if [ ! -f $cadir/certs/intermediate.cert.pem ]; then
    # Note 'openssl ca' does not support DER format
    openssl ca -config $cfgdir/openssl-root.cnf -days 3650 $passin \
            -extensions v3_intermediate_ca -notext -md sha256 -batch \
            -in $intdir/csr/intermediate.csr.$format\
            -out $cadir/certs/intermediate.cert.pem
    chmod 444 $cadir/certs/intermediate.cert.$format
    rm -f $cadir/certs/ca-chain.cert.$format
fi

openssl verify -CAfile $cadir/certs/ca.cert.$format\
     $cadir/certs/intermediate.cert.$format

openssl x509 -noout -text -in $cadir/certs/intermediate.cert.$format

# Create the certificate chain file

if [ ! -f $cadir/certs/ca-chain.cert.$format ]; then
    cat $cadir/certs/intermediate.cert.$format\
        $cadir/certs/ca.cert.$format > $cadir/certs/ca-chain.cert.$format
    chmod 444 $cadir/certs/ca-chain.cert.$format
fi
