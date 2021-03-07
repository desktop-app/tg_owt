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

# libabsl
# HINT: System abseil should be built with -DCMAKE_CXX_STANDARD=17
function(link_libabsl target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(absl)
        set(absl_FOUND ${absl_FOUND} PARENT_SCOPE)
        if (absl_FOUND)
            target_link_libraries(${target_name} INTERFACE absl::strings)
        endif()
    endif()
    if (NOT absl_FOUND)
        target_link_libraries(${target_name} PRIVATE tg_owt::libabsl)
    endif()
endfunction()

# libopenh264
function(link_libopenh264 target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(LIBOPENH264 openh264)
        set(LIBOPENH264_FOUND ${LIBOPENH264_FOUND} PARENT_SCOPE)
        if (LIBOPENH264_FOUND)
            target_link_libraries(${target_name} PRIVATE ${LIBOPENH264_LIBRARIES})
            target_include_directories(${target_name} PRIVATE ${LIBOPENH264_INCLUDE_DIRS})
        endif()
    endif()
    if (NOT LIBOPENH264_FOUND)
        target_link_libraries(${target_name} PRIVATE tg_owt::libopenh264)
        target_include_directories(${target_name} PRIVATE ${libopenh264_loc}/include)
    endif()
endfunction()

# libusrsctp
function(link_libusrsctp target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(LIBUSRSCTP usrsctp)
        set(LIBUSRSCTP_FOUND ${LIBUSRSCTP_FOUND} PARENT_SCOPE)
        if (LIBUSRSCTP_FOUND)
            target_link_libraries(${target_name} PRIVATE ${LIBUSRSCTP_LIBRARIES})
            target_include_directories(${target_name} PRIVATE ${LIBUSRSCTP_INCLUDE_DIRS})
        endif()
    endif()
    if (NOT LIBUSRSCTP_FOUND)
        target_link_libraries(${target_name} PRIVATE tg_owt::libusrsctp)
    endif()
endfunction()

# libvpx
function(link_libvpx target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(LIBVPX vpx>=1.10.0)
        set(LIBVPX_FOUND ${LIBVPX_FOUND} PARENT_SCOPE)
        if (LIBVPX_FOUND)
            target_link_libraries(${target_name} PRIVATE ${LIBVPX_LIBRARIES})
            target_include_directories(${target_name} PRIVATE ${LIBVPX_INCLUDE_DIRS})
        endif()
    endif()
    if (NOT LIBVPX_FOUND)
        target_link_libraries(${target_name} PRIVATE tg_owt::libvpx)
        if (is_x86 OR is_x64)
            target_link_libraries(${target_name}
            PRIVATE
                tg_owt::libvpx_mmx
                tg_owt::libvpx_sse2
                tg_owt::libvpx_ssse3
                tg_owt::libvpx_sse4
                tg_owt::libvpx_avx
                tg_owt::libvpx_avx2
            )
        endif()
    endif()
endfunction()

# libevent
function(link_libevent target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(LIBEVENT libevent)
        set(LIBEVENT_FOUND ${LIBEVENT_FOUND} PARENT_SCOPE)
        if (LIBEVENT_FOUND)
            target_link_libraries(${target_name} PRIVATE ${LIBEVENT_LIBRARIES})
            target_include_directories(${target_name} PRIVATE ${LIBEVENT_INCLUDE_DIRS})
        endif()
    endif()
    if (NOT LIBEVENT_FOUND)
        target_link_libraries(${target_name} PRIVATE tg_owt::libevent)
    endif()
endfunction()
