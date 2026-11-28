add_library(libsframe OBJECT EXCLUDE_FROM_ALL)
init_target(libsframe)
add_library(tg_owt::libsframe ALIAS libsframe)

link_openssl(libsframe)

set(libsframe_loc ${third_party_loc}/sframe/src)
set(libsframe_gen_loc ${CMAKE_CURRENT_BINARY_DIR}/gen/third_party/sframe)

set(SFRAME_CXX_NAMESPACE sframe)
configure_file(
    ${libsframe_loc}/cmake/namespace.h.in
    ${libsframe_gen_loc}/namespace.h
    @ONLY
)

nice_target_sources(libsframe ${libsframe_loc}
PRIVATE
    include/sframe/map.h
    include/sframe/result.h
    include/sframe/sframe.h
    include/sframe/span.h
    include/sframe/vector.h
    src/crypto.cpp
    src/crypto.h
    src/crypto_openssl3.cpp
    src/header.cpp
    src/header.h
    src/result.cpp
    src/sframe.cpp
)

target_sources(libsframe PRIVATE ${libsframe_gen_loc}/namespace.h)

target_compile_definitions(libsframe PRIVATE OPENSSL_3)

target_include_directories(libsframe
PUBLIC
    $<BUILD_INTERFACE:${libsframe_loc}/include>
    $<BUILD_INTERFACE:${libsframe_gen_loc}>
    $<INSTALL_INTERFACE:${webrtc_includedir}/third_party/sframe/src/include>
    $<INSTALL_INTERFACE:${webrtc_includedir}/third_party/sframe>
)

install(
    FILES ${libsframe_gen_loc}/namespace.h
    DESTINATION ${webrtc_includedir}/third_party/sframe
)
