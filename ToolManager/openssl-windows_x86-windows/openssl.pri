
#LIBS += -L$$PWD/lib -llibcrypto -llibssl
LIBS += -L$$PWD/lib -llibeay32 -lssleay32

INCLUDEPATH += $$PWD/include/openssl $$PWD/include/

HEADERS += \
    $$PWD/include/openssl/aes.h \
    $$PWD/include/openssl/asn1.h \
    $$PWD/include/openssl/asn1_mac.h \
    $$PWD/include/openssl/asn1t.h \
    $$PWD/include/openssl/async.h \
    $$PWD/include/openssl/bio.h \
    $$PWD/include/openssl/blowfish.h \
    $$PWD/include/openssl/bn.h \
    $$PWD/include/openssl/buffer.h \
    $$PWD/include/openssl/camellia.h \
    $$PWD/include/openssl/cast.h \
    $$PWD/include/openssl/cmac.h \
    $$PWD/include/openssl/cms.h \
    $$PWD/include/openssl/comp.h \
    $$PWD/include/openssl/conf.h \
    $$PWD/include/openssl/conf_api.h \
    $$PWD/include/openssl/crypto.h \
    $$PWD/include/openssl/ct.h \
    $$PWD/include/openssl/des.h \
    $$PWD/include/openssl/dh.h \
    $$PWD/include/openssl/dsa.h \
    $$PWD/include/openssl/dtls1.h \
    $$PWD/include/openssl/e_os2.h \
    $$PWD/include/openssl/ebcdic.h \
    $$PWD/include/openssl/ec.h \
    $$PWD/include/openssl/ecdh.h \
    $$PWD/include/openssl/ecdsa.h \
    $$PWD/include/openssl/engine.h \
    $$PWD/include/openssl/err.h \
    $$PWD/include/openssl/evp.h \
    $$PWD/include/openssl/hmac.h \
    $$PWD/include/openssl/idea.h \
    $$PWD/include/openssl/kdf.h \
    $$PWD/include/openssl/lhash.h \
    $$PWD/include/openssl/md2.h \
    $$PWD/include/openssl/md4.h \
    $$PWD/include/openssl/md5.h \
    $$PWD/include/openssl/mdc2.h \
    $$PWD/include/openssl/modes.h \
    $$PWD/include/openssl/obj_mac.h \
    $$PWD/include/openssl/objects.h \
    $$PWD/include/openssl/ocsp.h \
    $$PWD/include/openssl/opensslconf.h \
    $$PWD/include/openssl/opensslv.h \
    $$PWD/include/openssl/ossl_typ.h \
    $$PWD/include/openssl/pem.h \
    $$PWD/include/openssl/pem2.h \
    $$PWD/include/openssl/pkcs12.h \
    $$PWD/include/openssl/pkcs7.h \
    $$PWD/include/openssl/rand.h \
    $$PWD/include/openssl/rc2.h \
    $$PWD/include/openssl/rc4.h \
    $$PWD/include/openssl/rc5.h \
    $$PWD/include/openssl/ripemd.h \
    $$PWD/include/openssl/rsa.h \
    $$PWD/include/openssl/safestack.h \
    $$PWD/include/openssl/seed.h \
    $$PWD/include/openssl/sha.h \
    $$PWD/include/openssl/srp.h \
    $$PWD/include/openssl/srtp.h \
    $$PWD/include/openssl/ssl.h \
    $$PWD/include/openssl/ssl2.h \
    $$PWD/include/openssl/ssl3.h \
    $$PWD/include/openssl/stack.h \
    $$PWD/include/openssl/symhacks.h \
    $$PWD/include/openssl/tls1.h \
    $$PWD/include/openssl/ts.h \
    $$PWD/include/openssl/txt_db.h \
    $$PWD/include/openssl/ui.h \
    $$PWD/include/openssl/whrlpool.h \
    $$PWD/include/openssl/x509.h \
    $$PWD/include/openssl/x509_vfy.h \
    $$PWD/include/openssl/x509v3.h
