# Create passworded keypair file

openssl genpkey -aes256 -algorithm ec\
    -pkeyopt ec_paramgen_curve:prime256v1\
    -outform $format -pkeyopt ec_param_enc:named_curve\
    -out $dir/private/ca.key.$format
chmod 400 $dir/private/ca.key.$format
openssl pkey -inform $format -in $dir/private/ca.key.$format\
    -text -noout

# Create Self-signed Root Certificate file
# 7300 days = 20 years; Intermediate CA is 10 years.

openssl req -config $dir/openssl-root.cnf\
     -set_serial 0x$(openssl rand -hex $sn)\
     -keyform $format -outform $format\
     -key $dir/private/ca.key.$format -subj "$DN"\
     -new -x509 -days 7300 -sha256 -extensions v3_ca\
     -out $dir/certs/ca.cert.$format

#

openssl x509 -inform $format -in $dir/certs/ca.cert.$format\
     -text -noout
openssl x509 -purpose -inform $format\
     -in $dir/certs/ca.cert.$format -inform $format
