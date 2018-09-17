
# Select which Intermediate level
intermediate=intermediate
#intermediate=8021ARintermediate
dir=$cadir/$intermediate
crl=$intermediate.crl.pem

# Create CRL file
openssl ca -config $dir/openssl-$intermediate.cnf \
      -gencrl -out $dir/crl/$crl
chmod 444 $dir/crl/$crl

openssl crl -in $dir/crl/$crl -noout -text

