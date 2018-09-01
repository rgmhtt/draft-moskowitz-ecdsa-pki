
targetcert=fqdn
#targetcert=clientemail
#targetcert=DevID

openssl ocsp -CAfile $dir/certs/ca-chain.cert.pem \
      -url http://127.0.0.1:2560 -resp_text -sha256\
      -issuer $dir/certs/$intermediate.cert.pem \
      -cert $dir/certs/$targetcert.cert.pem

