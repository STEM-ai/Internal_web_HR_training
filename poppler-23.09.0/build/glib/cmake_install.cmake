# Install script for directory: /home/runner/FAQ-Langchain/poppler-23.09.0/glib

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
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-glib.so.8.26.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-glib.so.8"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "/nix/store/b9f9c4ml2k6fg0pgc80d9y4a6byqflmp-cairo-1.18.0/lib:/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:/nix/store/c2v6ycn0sjcpx9ww8x7j4ima6xnpssry-glib-2.80.2/lib")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/glib/libpoppler-glib.so.8.26.0"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/glib/libpoppler-glib.so.8"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-glib.so.8.26.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-glib.so.8"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "/home/runner/FAQ-Langchain/poppler-23.09.0/build:/nix/store/b9f9c4ml2k6fg0pgc80d9y4a6byqflmp-cairo-1.18.0/lib:/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:/nix/store/c2v6ycn0sjcpx9ww8x7j4ima6xnpssry-glib-2.80.2/lib:"
           NEW_RPATH "/nix/store/b9f9c4ml2k6fg0pgc80d9y4a6byqflmp-cairo-1.18.0/lib:/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:/nix/store/c2v6ycn0sjcpx9ww8x7j4ima6xnpssry-glib-2.80.2/lib")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/glib/libpoppler-glib.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/poppler/glib" TYPE FILE FILES
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-action.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-date.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-document.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-page.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-attachment.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-form-field.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-annot.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-layer.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-movie.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-media.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/glib/poppler-structure-element.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/glib/poppler-enums.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/glib/poppler-features.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/glib/poppler-macros.h"
    )
endif()

