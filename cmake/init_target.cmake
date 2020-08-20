# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

function(init_target target_name) # init_target(my_target folder_name)
    if (WIN32)
        target_compile_features(${target_name} PUBLIC cxx_std_17)
    elseif (APPLE)
        target_compile_features(${target_name} PUBLIC cxx_std_14)
    else()
        target_compile_features(${target_name} PUBLIC cxx_std_20)
    endif()
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set_target_properties(${target_name} PROPERTIES
            MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
    set_target_properties(${target_name} PROPERTIES
        XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_WEAK YES
        XCODE_ATTRIBUTE_GCC_INLINES_ARE_PRIVATE_EXTERN YES
        XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN YES
    )
    if (TG_OWT_PACKAGED_BUILD)
    else()
        set_target_properties(${target_name} PROPERTIES
            XCODE_ATTRIBUTE_GCC_OPTIMIZATION_LEVEL $<IF:$<CONFIG:Debug>,0,fast>
            XCODE_ATTRIBUTE_LLVM_LTO $<IF:$<CONFIG:Debug>,NO,YES>
        )
    endif()
    if (WIN32)
        target_compile_definitions(${target_name}
        PRIVATE
            WIN32_LEAN_AND_MEAN
            HAVE_WINSOCK2_H
            NOMINMAX
            HAVE_SSE2
            HAVE_SCTP
            ABSL_ALLOCATOR_NOTHROW=1
        )

        target_compile_options(${target_name}
        PRIVATE
            /arch:AVX2
            /W1
            /wd4715 # not all control paths return a value.
            /wd4244 # 'initializing' conversion from .. to .., possible loss of data.
            /wd4838 # conversion from .. to .. requires a narrowing conversion.
            /wd4305 # 'return': truncation from 'int' to 'bool'.
            /MP     # Enable multi process build.
            /EHsc   # Catch C++ exceptions only, extern C functions never throw a C++ exception.
            /Zc:wchar_t- # don't tread wchar_t as builtin type
            /Zi
        )
    else()
        if (APPLE)
            target_compile_options(${target_name}
            PRIVATE
                -Wno-deprecated-declarations
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

        target_compile_options(${target_name}
        PRIVATE
            -msse2
            -mssse3
            -msse4.1
            -mmmx
            -mavx
            -mavx2
        )
        target_compile_definitions(${target_name}
        PRIVATE
            HAVE_NETINET_IN_H
        )
    endif()
endfunction()
