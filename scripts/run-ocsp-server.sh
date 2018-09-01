
dir=/root/ca/intermediate
ocspurl=ocsp.htt-consult.com

openssl ocsp -port 2560 -text -rmd sha256\
      -index $dir/index.txt \
      -CA $dir/certs/ca-chain.cert.pem \
      -rkey $dir/private/$ocspurl.key.pem \
      -rsigner $dir/certs/$ocspurl.cert.pem \
      -nrequest 1

