add_library(libsrtp OBJECT)
init_target(libsrtp)
add_library(tg_owt::libsrtp ALIAS libsrtp)

link_openssl(libsrtp)

set(libsrtp_loc ${third_party_loc}/libsrtp)

nice_target_sources(libsrtp ${libsrtp_loc}
PRIVATE
    crypto/cipher/aes_gcm_ossl.c
    crypto/cipher/aes_icm_ossl.c
    crypto/cipher/cipher.c
    crypto/cipher/null_cipher.c
    crypto/hash/auth.c
    crypto/hash/hmac_ossl.c
    crypto/hash/null_auth.c
    crypto/kernel/alloc.c
    crypto/kernel/crypto_kernel.c
    crypto/kernel/err.c
    crypto/kernel/key.c
    crypto/math/datatypes.c
    crypto/math/stat.c
    crypto/replay/rdb.c
    crypto/replay/rdbx.c
    crypto/replay/ut_sim.c
    srtp/ekt.c
    srtp/srtp.c
)

target_include_directories(libsrtp
PUBLIC
    ${libsrtp_loc}/include
    ${libsrtp_loc}/crypto/include
)
