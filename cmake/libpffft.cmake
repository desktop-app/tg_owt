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

target_include_directories(libpffft
PUBLIC
    ${libpffft_loc}
)
