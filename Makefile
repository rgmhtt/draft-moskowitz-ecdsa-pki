VERSION=$(shell ./getver ${DRAFT}.xml )

# insert your ID here for the "submit" target
IETFUSER?=mcr+ietf@sandelman.ca
DRAFT=draft-moskowitz-ecdsa-pki
EXTRA_FILES=
EXTRA_FILES+=scripts/setup1.sh
EXTRA_FILES+=scripts/crl-creation.sh
EXTRA_FILES+=scripts/end-client.sh
EXTRA_FILES+=scripts/end-server.sh
EXTRA_FILES+=scripts/idevid-csr-cert.sh
EXTRA_FILES+=scripts/intermediate_1ar_cert.sh
EXTRA_FILES+=scripts/intermediate_1ar_setup.sh
EXTRA_FILES+=scripts/intermediate_cert.sh
EXTRA_FILES+=scripts/intermediate_setup.sh
EXTRA_FILES+=scripts/ocsp-setup.sh
EXTRA_FILES+=scripts/revoke-step1.sh
EXTRA_FILES+=scripts/rootcert.sh
EXTRA_FILES+=scripts/run-ocsp-server.sh
EXTRA_FILES+=scripts/san-creation-pipe.sh
EXTRA_FILES+=scripts/test-ocsp-server.sh
EXTRA_FILES+=configs/openssl-8021ARintermediate.cnf
EXTRA_FILES+=configs/openssl-intermediate.cnf
EXTRA_FILES+=configs/openssl-root.cnf

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt ${DRAFT}.html
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt
	cp ${DRAFT}.html ${DRAFT}-${VERSION}.html
	@echo Consider a \'git add\' of html version

examples/%.txt: examples/%.crt
	openssl x509 -noout -text -in $? | fold -w 60 >$@

examples/%.asn1.txt: examples/%.pkcs
	base64 --decode <$? |	openssl asn1parse -inform der | fold -w 60 >$@

examples/%.asn1.txt: examples/%.crt
	openssl asn1parse -in $? | fold -w 60 >$@

examples/%.json: examples/%.pkcs
	base64 --decode <$? | openssl cms -verify -inform der -nosigs -noverify | fold -w 60 >$@

ALL-${DRAFT}.xml: ${DRAFT}.xml ${EXTRA_FILES}
	cat ${DRAFT}.xml | ./insert-figures > ALL-${DRAFT}.xml

%.txt: ALL-%.xml
	@echo PROCESSING: $(subst ALL-,,$@)
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --text -o $(subst ALL-,,$@) $?

%.html: ALL-%.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $(subst ALL-,,$@) $?

submit: ALL-${DRAFT}.xml
	curl -S -F "user=${IETFUSER}" -F "xml=@ALL-${DRAFT}.xml" https://datatracker.ietf.org/api/submit

clean:
	-rm -f ${DRAFT}-${VERSION}.xml ${DRAFT}-${VERSION}.txt
	-rm -f ALL-${DRAFT}-${VERSION}.xml
	-rm -f ALL-${DRAFT}.xml
	-rm -f *~

.PRECIOUS: ${DRAFT}-${VERSION}.xml
.PRECIOUS: ${VRDATE}
.PRECIOUS: ALL-${DRAFT}.xml
.PRECIOUS: DATE-${DRAFT}.xml

version:
	@echo Version: ${VERSION}

vars:
	@echo Version: ${VERSION}
	@echo IETFuser: ${IETFUSER}
