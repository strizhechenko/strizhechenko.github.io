---
title: SEC_ERROR_REVOKED_CERTIFICATE
---

How to be 100% sure your SSL cert is really has been revoked:

1. https://www.ssllabs.com/ssltest/
2. CTRL-F Revocation status
3. If not revoked everything ok
4. Else, find Revocation information	CRL, OCSP
    1. CRL: http://crl.comodoca.com/COMODORSADomainValidationSecureServerCA.crl
    2. OCSP: http://ocsp.comodoca.com
4. Find Your cert serial number. I only got it via Safari that didn't updated revocation lists yet, firefox show no debug/info if found an error.
5. `wget "http://crl.comodoca.com/COMODORSADomainValidationSecureServerCA.crl" -O COMODORSADomainValidationSecureServerCA.crl`
6. `openssl crl -inform DER -text -noout -in COMODORSADomainValidationSecureServerCA.crl | grep -A 1 YOUR_CERT_SERIAL_NUMBER_WITHOUT_SPACES`
