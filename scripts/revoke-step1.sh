
targetcert=fqdn
#targetcert=clientemail
#targetcert=DevID

openssl ca -config $dir/openssl-$intermediate.cnf\
 -revoke $dir/certs/$targetcert.cert.$format

