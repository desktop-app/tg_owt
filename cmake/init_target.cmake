# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

function(init_target_folder target_name folder_name)
    if (NOT "${folder_name}" STREQUAL "")
        set_target_properties(${target_name} PROPERTIES FOLDER ${folder_name})
    endif()
endfunction()

function(init_target target_name) # init_target(my_target folder_name)
    target_compile_features(${target_name} PUBLIC cxx_std_20)

    target_compile_definitions(${target_name}
    PRIVATE
        HAVE_SCTP
        ABSL_ALLOCATOR_NOTHROW=1
    )
    if (WIN32)
        target_compile_definitions(${target_name}
        PRIVATE
            WIN32_LEAN_AND_MEAN
            NOMINMAX
            HAVE_WINSOCK2_H
            HAVE_WINDOWS_H
            HAVE_X86
            HAVE_SSE2
        )

        if (MSVC) # implies not MINGW
            target_compile_options(${target_name}
            PRIVATE
                /W1
                /wd4715 # not all control paths return a value.
                /wd4244 # 'initializing' conversion from .. to .., possible loss of data.
                /wd4838 # conversion from .. to .. requires a narrowing conversion.
                /wd4305 # 'return': truncation from 'int' to 'bool'.
                /wd4068 # unknown pragma 'clang'

                # C++20: enum-s used as constants in WebRTC code.
                /wd5055 # operator 'X': deprecated between enumerations and floating-point types

                /MP     # Enable multi process build.
                /EHsc   # Catch C++ exceptions only, extern C functions never throw a C++ exception.
                # /Zc:wchar_t- # don't tread wchar_t as builtin type
            )
        endif()
    else()
        if (APPLE)
            target_compile_options(${target_name}
            PRIVATE
                -Wno-deprecated-declarations

                # C++20: volatile arithmetics in RaceChecker.
                -Wno-deprecated-volatile

                # C++20: enum-s used as constants in WebRTC code.
                -Wno-deprecated-anon-enum-enum-conversion

                -fobjc-arc
                -fvisibility=hidden
                -fvisibility-inlines-hidden
            )
        else()
            target_compile_options(${target_name}
            PRIVATE
                -Wno-deprecated-declarations
                -Wno-attributes
                -Wno-narrowing
                -Wno-return-type
            )
        endif()

        if (is_x86)
            target_compile_options(${target_name}
            PRIVATE
                -msse2
            )
        endif()

        target_compile_definitions(${target_name}
        PRIVATE
            HAVE_NETINET_IN_H
        )
    endif()
endfunction()

function(init_feature_target target_name feature)
    init_target(${target_name})

    set(option "")
    if (MSVC)
        if (${feature} STREQUAL "avx")
            set(option /arch:AVX)
        elseif (${feature} STREQUAL "avx2")
            set(option /arch:AVX2)
        endif()
    else()
        if (${feature} STREQUAL "mmx")
            set(option -mmmx)
        elseif (${feature} STREQUAL "sse2")
            set(option -msse2)
        elseif (${feature} STREQUAL "ssse3")
            set(option -mssse3)
        elseif (${feature} STREQUAL "sse4")
            set(option -msse4.1)
        elseif (${feature} STREQUAL "avx")
            set(option -mavx)
        elseif (${feature} STREQUAL "avx2")
            set(option -mavx2 -mfma)
        endif()
        target_compile_options(${target_name}
        PRIVATE
            ${posix_option}
        )
    endif()
    if (NOT "${option}" STREQUAL "")
        target_compile_options(${target_name}
        PRIVATE
            ${option}
        )
    endif()
endfunction()
