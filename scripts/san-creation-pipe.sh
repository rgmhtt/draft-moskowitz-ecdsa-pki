openssl req -new -sha256 -key domain.key\
 -subj "/C=US/ST=CA/O=Acme, Inc./CN=foo.com" -reqexts SAN\
  -config <(cat /etc/ssl/openssl.cnf\
   <(printf "[SAN]\nsubjectAltName=DNS:foo.com,DNS:www.foo.com"))\
  -out domain.csr

