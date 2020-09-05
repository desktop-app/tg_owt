# OpenSSL
set(TG_OWT_OPENSSL_INCLUDE_PATH "" CACHE STRING "Include path for openssl.")
function(link_openssl target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(OpenSSL REQUIRED)
        target_include_directories(${target_name} PRIVATE ${OPENSSL_INCLUDE_DIR})
        target_link_libraries(${target_name} PRIVATE ${OPENSSL_LIBRARIES})
    else()
        if (TG_OWT_OPENSSL_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_OPENSSL_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name}
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
        target_include_directories(${target_name} PRIVATE ${OPUS_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${OPUS_LINK_LIBRARIES})
    else()
        if (TG_OWT_OPUS_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_OPUS_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name}
        PRIVATE
            ${TG_OWT_OPUS_INCLUDE_PATH}
        )
    endif()
endfunction()

# FFmpeg
set(TG_OWT_FFMPEG_INCLUDE_PATH "" CACHE STRING "Include path for ffmpeg.")
option(TG_OWT_PACKAGED_BUILD_FFMPEG_STATIC "Link ffmpeg statically in packaged mode." OFF)
function(link_ffmpeg target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(AVCODEC REQUIRED libavcodec)
        pkg_check_modules(AVFORMAT REQUIRED libavformat)
        pkg_check_modules(AVUTIL REQUIRED libavutil)
        pkg_check_modules(SWSCALE REQUIRED libswscale)
        pkg_check_modules(SWRESAMPLE REQUIRED libswresample)
        target_include_directories(${target_name} PRIVATE
            ${AVCODEC_INCLUDE_DIRS}
            ${AVFORMAT_INCLUDE_DIRS}
            ${AVUTIL_INCLUDE_DIRS}
            ${SWSCALE_INCLUDE_DIRS}
            ${SWRESAMPLE_INCLUDE_DIRS}
        )
        if (TG_OWT_PACKAGED_BUILD_FFMPEG_STATIC)
            target_link_libraries(${target_name}
            PRIVATE
                ${AVCODEC_STATIC_LINK_LIBRARIES}
                ${AVFORMAT_STATIC_LINK_LIBRARIES}
                ${AVUTIL_STATIC_LINK_LIBRARIES}
                ${SWSCALE_STATIC_LINK_LIBRARIES}
                ${SWRESAMPLE_STATIC_LINK_LIBRARIES}
            )
        else()
            target_link_libraries(${target_name}
            PRIVATE
                ${AVCODEC_LINK_LIBRARIES}
                ${AVFORMAT_LINK_LIBRARIES}
                ${AVUTIL_LINK_LIBRARIES}
                ${SWSCALE_LINK_LIBRARIES}
                ${SWRESAMPLE_LINK_LIBRARIES}
            )
        endif()
    else()
        if (TG_OWT_FFMPEG_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_FFMPEG_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name}
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
        target_include_directories(${target_name} PRIVATE ${JPEG_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${JPEG_LIBRARIES})
    else()
        if (TG_OWT_LIBJPEG_INCLUDE_PATH STREQUAL "")
            message(FATAL_ERROR "You should specify 'TG_OWT_LIBJPEG_INCLUDE_PATH'.")
        endif()

        target_include_directories(${target_name}
        PRIVATE
            ${TG_OWT_LIBJPEG_INCLUDE_PATH}
            ${TG_OWT_LIBJPEG_INCLUDE_PATH}/src
        )
    endif()
endfunction()

# alsa
set(TG_OWT_ALSA_INCLUDE_PATH "" CACHE STRING "Include path for alsa-lib.")
function(link_libalsa target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(ALSA REQUIRED)
        target_include_directories(${target_name} PRIVATE ${ALSA_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${ALSA_LIBRARIES})
    endif()
endfunction()

# pulseaudio
set(TG_OWT_LIBPULSE_INCLUDE_PATH "" CACHE STRING "Include path for pulse-audio.")
function(link_libpulse target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PulseAudio REQUIRED)
        target_include_directories(${target_name} PRIVATE ${PULSEAUDIO_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${PULSEAUDIO_LIBRARIES})
    endif()
endfunction()

# libvpx
function(link_vpx target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(VPX vpx)
    endif()
    if (VPX_FOUND)
        target_include_directories(${target_name} PRIVATE ${VPX_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${VPX_LINK_LIBRARIES})
    else()
        include("${CMAKE_CURRENT_LIST_DIR}/cmake/libvpx.cmake")
        target_link_libraries(${target_name}
        PRIVATE
            tg_owt::libvpx
            tg_owt::libvpx_mmx
            tg_owt::libvpx_sse2
            tg_owt::libvpx_ssse3
            tg_owt::libvpx_sse4
            tg_owt::libvpx_avx
            tg_owt::libvpx_avx2
        )
    endif()
endfunction()
