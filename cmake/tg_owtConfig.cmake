include(CMakeFindDependencyMacro)
if (@absl_FOUND@)
    find_dependency(absl @absl_VERSION@)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/tg_owtTargets.cmake")
