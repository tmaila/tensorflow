include (ExternalProject)

set(GRPC_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc/include)
set(GRPC_URL https://github.com/grpc/grpc.git)
set(GRPC_BUILD ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc)
set(GRPC_TAG 3bc78cd0b5bd784a235c01612d634b1ec5f8fb97)

if(WIN32)
  set(grpc_STATIC_LIBRARIES
      ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc/${CMAKE_BUILD_TYPE}/grpc++_unsecure.lib
      ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc/${CMAKE_BUILD_TYPE}/grpc_unsecure.lib
      ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc/${CMAKE_BUILD_TYPE}/gpr.lib)
else()
  set(grpc_STATIC_LIBRARIES
      ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc/libgrpc++_unsecure.a
      ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc/libgrpc_unsecure.a
      ${CMAKE_CURRENT_BINARY_DIR}/grpc/src/grpc/libgpr.a)
endif()

ExternalProject_Add(grpc
    PREFIX grpc
    DEPENDS protobuf zlib
    GIT_REPOSITORY ${GRPC_URL}
    GIT_TAG ${GRPC_TAG}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/patches/grpc/CMakeLists.txt ${GRPC_BUILD}
    INSTALL_COMMAND ""
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
        -DPROTOBUF_INCLUDE_DIRS:STRING=${PROTOBUF_INCLUDE_DIRS}
        -DPROTOBUF_LIBRARIES:STRING=${protobuf_STATIC_LIBRARIES}
        -DZLIB_ROOT:STRING=${ZLIB_INSTALL}
)

