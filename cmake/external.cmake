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
        target_link_libraries(${target_name} PRIVATE ${OPUS_LIBRARIES})
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
        target_link_libraries(${target_name} PRIVATE
            ${AVCODEC_LIBRARIES}
            ${AVFORMAT_LIBRARIES}
            ${AVUTIL_LIBRARIES}
            ${SWSCALE_LIBRARIES}
            ${SWRESAMPLE_LIBRARIES}
        )
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
