# Install script for directory: /home/runner/FAQ-Langchain/poppler-23.09.0

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/var/empty/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "RelWithDebInfo")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler.so.131.0.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler.so.131"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/lv6nackqis28gg7l2ic43f6nk52hb39g-zlib-1.3.1/lib:/nix/store/azbphnp68h4fkm0fsbird88bn76ggjsh-fontconfig-2.15.0-lib/lib:/nix/store/pgj3xdvp8hj61wwkcw2k0wfbyr3ni64h-libjpeg-turbo-3.0.3/lib:/nix/store/36kr91f8s509z2r8hqvpayw5bqyqgyzr-curl-8.7.1/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:/nix/store/nxz7xvlvf88pkrlkxcn1nbkjzgibvyc4-lcms2-2.16/lib:/nix/store/55kivg8damd3y2c5k7286nvckw8pb2xf-libpng-apng-1.6.43/lib:/nix/store/ic5bx78h039m3lfxxb6bl64qlbdxzzj9-libtiff-4.6.0/lib:/nix/store/lr06m26d9qh6ssa3x5zx2ll33wm44xid-nss-3.90.2/lib64:/nix/store/8a651pfg6s4z27j274baqqb57pp34jkf-nspr-4.35/lib")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/libpoppler.so.131.0.0"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/libpoppler.so.131"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler.so.131.0.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler.so.131"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/lv6nackqis28gg7l2ic43f6nk52hb39g-zlib-1.3.1/lib:/nix/store/azbphnp68h4fkm0fsbird88bn76ggjsh-fontconfig-2.15.0-lib/lib:/nix/store/pgj3xdvp8hj61wwkcw2k0wfbyr3ni64h-libjpeg-turbo-3.0.3/lib:/nix/store/36kr91f8s509z2r8hqvpayw5bqyqgyzr-curl-8.7.1/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:/nix/store/nxz7xvlvf88pkrlkxcn1nbkjzgibvyc4-lcms2-2.16/lib:/nix/store/55kivg8damd3y2c5k7286nvckw8pb2xf-libpng-apng-1.6.43/lib:/nix/store/ic5bx78h039m3lfxxb6bl64qlbdxzzj9-libtiff-4.6.0/lib:/nix/store/lr06m26d9qh6ssa3x5zx2ll33wm44xid-nss-3.90.2/lib64:/nix/store/8a651pfg6s4z27j274baqqb57pp34jkf-nspr-4.35/lib:"
           NEW_RPATH "/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/lv6nackqis28gg7l2ic43f6nk52hb39g-zlib-1.3.1/lib:/nix/store/azbphnp68h4fkm0fsbird88bn76ggjsh-fontconfig-2.15.0-lib/lib:/nix/store/pgj3xdvp8hj61wwkcw2k0wfbyr3ni64h-libjpeg-turbo-3.0.3/lib:/nix/store/36kr91f8s509z2r8hqvpayw5bqyqgyzr-curl-8.7.1/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:/nix/store/nxz7xvlvf88pkrlkxcn1nbkjzgibvyc4-lcms2-2.16/lib:/nix/store/55kivg8damd3y2c5k7286nvckw8pb2xf-libpng-apng-1.6.43/lib:/nix/store/ic5bx78h039m3lfxxb6bl64qlbdxzzj9-libtiff-4.6.0/lib:/nix/store/lr06m26d9qh6ssa3x5zx2ll33wm44xid-nss-3.90.2/lib64:/nix/store/8a651pfg6s4z27j274baqqb57pp34jkf-nspr-4.35/lib")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/libpoppler.so")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/runner/FAQ-Langchain/poppler-23.09.0/build/utils/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/runner/FAQ-Langchain/poppler-23.09.0/build/glib/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/runner/FAQ-Langchain/poppler-23.09.0/build/test/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/runner/FAQ-Langchain/poppler-23.09.0/build/qt5/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/runner/FAQ-Langchain/poppler-23.09.0/build/cpp/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/poppler.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/poppler-qt5.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/poppler-glib.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/poppler-cpp.pc")
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/runner/FAQ-Langchain/poppler-23.09.0/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
