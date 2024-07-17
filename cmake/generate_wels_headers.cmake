# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

function(generate_wels_headers target_name)
    set(gen_dst ${CMAKE_CURRENT_BINARY_DIR}/gen/openh264_include)
    file(MAKE_DIRECTORY ${gen_dst}/wels)

    set(gen_timestamp ${gen_dst}/wels_headers.timestamp)
    set(gen_files
        ${gen_dst}/wels/codec_api.h
        ${gen_dst}/wels/codec_app_def.h
        ${gen_dst}/wels/codec_def.h
        ${gen_dst}/wels/codec_ver.h
    )
    add_custom_command(
    OUTPUT
        ${gen_timestamp}
    BYPRODUCTS
        ${gen_files}
    COMMAND
        ${CMAKE_COMMAND}
        -E
        copy
        ${libopenh264_loc}/codec/api/wels/codec_api.h
        ${libopenh264_loc}/codec/api/wels/codec_app_def.h
        ${libopenh264_loc}/codec/api/wels/codec_def.h
        ${libopenh264_loc}/codec/api/wels/codec_ver.h
        ${gen_dst}/wels
    COMMAND
        echo 1> ${gen_timestamp}
    COMMENT "Generating wels headers copy (${target_name})"
    DEPENDS
        ${libopenh264_loc}/codec/api/wels/codec_api.h
        ${libopenh264_loc}/codec/api/wels/codec_app_def.h
        ${libopenh264_loc}/codec/api/wels/codec_def.h
        ${libopenh264_loc}/codec/api/wels/codec_ver.h
    )
    generate_target(${target_name} wels_headers ${gen_timestamp} "${gen_files}" ${gen_dst})
    target_include_directories(${target_name} PUBLIC $<BUILD_INTERFACE:${gen_dst}>)
endfunction()
