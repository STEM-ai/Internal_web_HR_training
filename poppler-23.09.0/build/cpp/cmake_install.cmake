# Install script for directory: /home/runner/FAQ-Langchain/poppler-23.09.0/cpp

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

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/runner/FAQ-Langchain/poppler-23.09.0/build/cpp/tests/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-cpp.so.0.11.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-cpp.so.0"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/cpp/libpoppler-cpp.so.0.11.0"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/cpp/libpoppler-cpp.so.0"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-cpp.so.0.11.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-cpp.so.0"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "/home/runner/FAQ-Langchain/poppler-23.09.0/build:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:"
           NEW_RPATH "/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/cpp/libpoppler-cpp.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/poppler/cpp" TYPE FILE FILES
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-destination.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-document.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-embedded-file.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-font.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-font-private.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-global.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-image.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-page.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-page-renderer.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-page-transition.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-rectangle.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/cpp/poppler-toc.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/cpp/poppler_cpp_export.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/cpp/poppler-version.h"
    )
endif()

