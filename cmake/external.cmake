# OpenSSL
set(TG_OWT_OPENSSL_INCLUDE_PATH "" CACHE STRING "Include path for openssl.")
function(link_openssl target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(OpenSSL REQUIRED)
        target_include_directories(${target_name} SYSTEM PRIVATE ${OPENSSL_INCLUDE_DIR})
        target_link_libraries(${target_name} PRIVATE ${OPENSSL_LIBRARIES})
    else()
        if (TG_OWT_OPENSSL_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_OPENSSL_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name} SYSTEM
        PRIVATE
            ${TG_OWT_OPENSSL_INCLUDE_PATH}
        )
    endif()
endfunction()

# Opus
set(TG_OWT_OPUS_INCLUDE_PATH "" CACHE STRING "Include path for opus.")
function(link_opus target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(OPUS REQUIRED opus)
        target_include_directories(${target_name} SYSTEM PRIVATE ${OPUS_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${OPUS_LINK_LIBRARIES})
    else()
        if (TG_OWT_OPUS_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_OPUS_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name} SYSTEM
        PRIVATE
            ${TG_OWT_OPUS_INCLUDE_PATH}
        )
    endif()
endfunction()

# FFmpeg
set(TG_OWT_FFMPEG_INCLUDE_PATH "" CACHE STRING "Include path for ffmpeg.")
function(link_ffmpeg target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(FFMPEG REQUIRED libavcodec libavformat libavutil libswresample libswscale)
        target_include_directories(${target_name} SYSTEM PRIVATE ${FFMPEG_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${FFMPEG_LINK_LIBRARIES})
    else()
        if (TG_OWT_FFMPEG_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_FFMPEG_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name} SYSTEM
        PRIVATE
            ${TG_OWT_FFMPEG_INCLUDE_PATH}
        )
    endif()
endfunction()

# libjpeg
set(TG_OWT_LIBJPEG_INCLUDE_PATH "" CACHE STRING "Include path for libjpeg.")
function(link_libjpeg target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(JPEG REQUIRED)
        target_include_directories(${target_name} SYSTEM PRIVATE ${JPEG_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${JPEG_LIBRARIES})
    else()
        if (TG_OWT_LIBJPEG_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_LIBJPEG_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name} SYSTEM
        PRIVATE
            ${TG_OWT_LIBJPEG_INCLUDE_PATH}
            ${TG_OWT_LIBJPEG_INCLUDE_PATH}/src
        )
    endif()
endfunction()

# libabsl
# HINT: System abseil should be built with -DCMAKE_CXX_STANDARD=20
function(link_libabsl target_name)
    set(scope PRIVATE)
    get_target_property(target_type ${target_name} TYPE)
    if (${target_type} STREQUAL "INTERFACE_LIBRARY")
        set(scope INTERFACE)
    endif()
    if (TG_OWT_PACKAGED_BUILD)
        find_package(absl)
        set(absl_FOUND ${absl_FOUND} PARENT_SCOPE)
        if (absl_FOUND)
            target_link_libraries(${target_name}
            ${scope}
                absl::algorithm_container
                absl::bind_front
                absl::config
                absl::core_headers
                absl::flat_hash_map
                absl::inlined_vector
                absl::flags
                absl::flags_parse
                absl::flags_usage
                absl::memory
                absl::optional
                absl::strings
                absl::synchronization
                absl::type_traits
                absl::variant
            )
        endif()
    endif()
    if (NOT absl_FOUND)
        target_link_libraries(${target_name} ${scope} tg_owt::libabsl)
    endif()
endfunction()

# libopenh264
set(TG_OWT_OPENH264_INCLUDE_PATH "" CACHE STRING "Include path for openh264.")
function(link_libopenh264 target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(OPENH264 REQUIRED openh264)
        target_link_libraries(${target_name} PRIVATE ${OPENH264_LINK_LIBRARIES})
        target_include_directories(${target_name} SYSTEM PRIVATE ${OPENH264_INCLUDE_DIRS})
    else()
        if (TG_OWT_OPENH264_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_OPENH264_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name} SYSTEM
        PRIVATE
            ${TG_OWT_OPENH264_INCLUDE_PATH}
        )
    endif()
endfunction()

# libSRTP
function(link_libsrtp target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig)
        if (PkgConfig_FOUND)
            pkg_check_modules(SRTP libsrtp2)
            if (SRTP_FOUND)
                target_include_directories(${target_name} SYSTEM PRIVATE ${SRTP_INCLUDE_DIRS})
                target_link_libraries(${target_name} PRIVATE ${SRTP_LINK_LIBRARIES})
            endif()
        endif()
    endif()
    if (NOT SRTP_FOUND)
        target_link_libraries(${target_name} PRIVATE tg_owt::libsrtp)
    endif()
endfunction()

# libvpx
set(TG_OWT_LIBVPX_INCLUDE_PATH "" CACHE STRING "Include path for libvpx.")
function(link_libvpx target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(VPX REQUIRED vpx>=1.10.0)
        target_link_libraries(${target_name} PRIVATE ${VPX_LINK_LIBRARIES})
        target_include_directories(${target_name} SYSTEM PRIVATE ${VPX_INCLUDE_DIRS})
    else()
        if (TG_OWT_LIBVPX_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_LIBVPX_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name} SYSTEM
        PRIVATE
            ${TG_OWT_LIBVPX_INCLUDE_PATH}
        )
    endif()
endfunction()

# crc32c
function(link_crc32c target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(Crc32c)
        set(Crc32c_FOUND ${Crc32c_FOUND} PARENT_SCOPE)
        if (Crc32c_FOUND)
            target_link_libraries(${target_name} PRIVATE Crc32c::crc32c)
        endif()
    endif()
    if (NOT Crc32c_FOUND)
        target_link_libraries(${target_name} PRIVATE tg_owt::libcrc32c)
    endif()
endfunction()

function(link_glib target_name)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(GLIB2 REQUIRED glib-2.0 gobject-2.0 gio-2.0 gio-unix-2.0)
    target_include_directories(${target_name} SYSTEM PRIVATE ${GLIB2_INCLUDE_DIRS})
    if (TG_OWT_PACKAGED_BUILD)
        target_link_libraries(${target_name} PRIVATE ${GLIB2_LINK_LIBRARIES})
    endif()
endfunction()

# x11
function(link_x11 target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(X11 REQUIRED x11 xcomposite xdamage xext xfixes xrandr xrender xtst)
        target_include_directories(${target_name} SYSTEM PRIVATE ${X11_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${X11_LINK_LIBRARIES})
    endif()
endfunction()

# PipeWire
function(link_pipewire target_name only_include_dirs)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(PIPEWIRE REQUIRED libpipewire-0.3)
    target_include_directories(${target_name} SYSTEM PRIVATE ${PIPEWIRE_INCLUDE_DIRS})
    if (NOT only_include_dirs)
        target_link_libraries(${target_name} PRIVATE ${PIPEWIRE_LINK_LIBRARIES})
    endif()
endfunction()

# Alsa
function(link_libalsa target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(ALSA REQUIRED)
        target_include_directories(${target_name} SYSTEM PRIVATE ${ALSA_INCLUDE_DIRS})
    endif()
endfunction()

# PulseAudio
function(link_libpulse target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(PULSE REQUIRED libpulse)
        target_include_directories(${target_name} SYSTEM PRIVATE ${PULSE_INCLUDE_DIRS})
    endif()
endfunction()

# dl
function(link_dl target_name)
    if (TG_OWT_PACKAGED_BUILD)
        target_link_libraries(${target_name} PRIVATE ${CMAKE_DL_LIBS})
    endif()
endfunction()
