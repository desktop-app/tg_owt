# OpenSSL
set(TG_OWT_OPENSSL_INCLUDE_PATH "" CACHE STRING "Include path for openssl.")

function(link_openssl target_name)
    if (TG_OWT_PACKAGED_BUILD)
        find_package(OpenSSL REQUIRED)
        target_link_libraries(${target_name} PUBLIC OpenSSL::Crypto OpenSSL::SSL)
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
        pkg_check_modules(OPUS REQUIRED IMPORTED_TARGET opus)
        target_link_libraries(${target_name} PUBLIC PkgConfig::OPUS)
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
        pkg_check_modules(AVCODEC REQUIRED IMPORTED_TARGET libavcodec)
        pkg_check_modules(AVFORMAT REQUIRED IMPORTED_TARGET libavformat)
        pkg_check_modules(AVUTIL REQUIRED IMPORTED_TARGET libavutil)
        pkg_check_modules(SWSCALE REQUIRED IMPORTED_TARGET libswscale)
        pkg_check_modules(SWRESAMPLE REQUIRED IMPORTED_TARGET libswresample)
        target_link_libraries(${target_name} PUBLIC
            PkgConfig::AVCODEC
            PkgConfig::AVFORMAT
            PkgConfig::AVUTIL
            PkgConfig::SWSCALE
            PkgConfig::SWRESAMPLE
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
        target_link_libraries(${target_name} PUBLIC JPEG::JPEG)
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
