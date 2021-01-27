add_library(libpffft OBJECT)
init_target(libpffft)
add_library(tg_owt::libpffft ALIAS libpffft)

set(libpffft_loc ${third_party_loc}/pffft/src)

nice_target_sources(libpffft ${libpffft_loc}
PRIVATE
    fftpack.c
    pffft.c
)

target_compile_definitions(libpffft
PRIVATE
    _USE_MATH_DEFINES
)

if (NOT x86_has_sse2 AND NOT arm_use_neon)
    target_compile_definitions(libpffft
    PRIVATE
        PFFFT_SIMD_DISABLE
    )
endif()

target_include_directories(libpffft
PUBLIC
    $<BUILD_INTERFACE:${libpffft_loc}>
    $<INSTALL_INTERFACE:${webrtc_includedir}/third_party/pffft/src>
)
