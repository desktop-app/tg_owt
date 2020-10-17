add_library(libusrsctp OBJECT)
init_target(libusrsctp)
add_library(tg_owt::libusrsctp ALIAS libusrsctp)

set(libusrsctp_loc ${third_party_loc}/usrsctp/usrsctplib/usrsctplib)

target_compile_definitions(libusrsctp
PRIVATE
    __Userspace__
    SCTP_SIMPLE_ALLOCATOR
    SCTP_PROCESS_LEVEL_LOCKS
)

if (WIN32)
    target_compile_definitions(libusrsctp
    PRIVATE
        __Userspace_os_Windows
    )
elseif (APPLE)
    target_compile_definitions(libusrsctp
    PRIVATE
        __Userspace_os_Darwin
    )
    target_compile_options(libusrsctp
    PRIVATE
        -U__APPLE__
    )
else()
    target_compile_definitions(libusrsctp
    PRIVATE
        __Userspace_os_Linux
    )
endif()

nice_target_sources(libusrsctp ${libusrsctp_loc}
PRIVATE
    netinet/sctp_asconf.c
    netinet/sctp_auth.c
    netinet/sctp_bsd_addr.c
    netinet/sctp_callout.c
    netinet/sctp_cc_functions.c
    netinet/sctp_crc32.c
    netinet/sctp_indata.c
    netinet/sctp_input.c
    netinet/sctp_output.c
    netinet/sctp_pcb.c
    netinet/sctp_peeloff.c
    netinet/sctp_sha1.c
    netinet/sctp_ss_functions.c
    netinet/sctp_sysctl.c
    netinet/sctp_timer.c
    netinet/sctp_userspace.c
    netinet/sctp_usrreq.c
    netinet/sctputil.c
    netinet6/sctp6_usrreq.c
    user_environment.c
    user_mbuf.c
    user_recv_thread.c
    user_socket.c
)

if (APPLE)
    remove_target_sources(libusrsctp ${libusrsctp_loc}
        netinet6/sctp6_usrreq.c
    )
endif()

target_include_directories(libusrsctp
PUBLIC
    $<BUILD_INTERFACE:${third_party_loc}/usrsctp/usrsctplib>
    $<BUILD_INTERFACE:${libusrsctp_loc}>
    $<INSTALL_INTERFACE:${webrtc_includedir}/third_party/usrsctp/usrsctplib/usrsctplib>
    $<INSTALL_INTERFACE:${webrtc_includedir}/third_party/usrsctp/usrsctplib>
)
