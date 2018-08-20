VERSION=$(shell ./getver ${DRAFT}.xml )

# insert your ID here for the "submit" target
IETFUSER=mcr+ietf@sandelman.ca
DRAFT=draft-moskowitz-ecdsa-pki
EXTRA_FILES+=scripts/setup1.sh

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
