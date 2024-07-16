# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

function(generate_field_trials target_name)
    find_package(Python REQUIRED)

    set(gen_dst ${CMAKE_CURRENT_BINARY_DIR}/gen)
    file(MAKE_DIRECTORY ${gen_dst}/experiments)

    set(gen_timestamp ${gen_dst}/field_trials.timestamp)
    set(gen_files
        ${gen_dst}/experiments/registered_field_trials.h
    )
    add_custom_command(
    OUTPUT
        ${gen_timestamp}
    BYPRODUCTS
        ${gen_files}
    COMMAND
        ${Python_EXECUTABLE}
        ${webrtc_loc}/experiments/field_trials.py
        header
        --output ${gen_dst}/experiments/registered_field_trials.h
    COMMAND
        echo 1> ${gen_timestamp}
    COMMENT "Generating field trials header (${target_name})"
    DEPENDS
        ${webrtc_loc}/experiments/field_trials.py
    )
    generate_target(${target_name} field_trials ${gen_timestamp} "${gen_files}" ${gen_dst})
endfunction()
