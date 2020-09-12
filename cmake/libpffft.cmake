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

if ((is_arm OR is_aarch64) AND (NOT arm_use_neon))
    target_compile_definitions(libpffft
    PRIVATE
        PFFFT_SIMD_DISABLE
    )
endif()

target_include_directories(libpffft
PUBLIC
    ${libpffft_loc}
)
