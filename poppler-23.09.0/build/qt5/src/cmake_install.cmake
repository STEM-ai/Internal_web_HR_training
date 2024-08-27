# Install script for directory: /home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src

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
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-qt5.so.1.33.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-qt5.so.1"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "/nix/store/qpk85xnnx7w7fc8zkiq6mav3n4jiiffr-qtbase-5.15.12/lib:/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/nxz7xvlvf88pkrlkxcn1nbkjzgibvyc4-lcms2-2.16/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/qt5/src/libpoppler-qt5.so.1.33.0"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/qt5/src/libpoppler-qt5.so.1"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-qt5.so.1.33.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpoppler-qt5.so.1"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "/nix/store/qpk85xnnx7w7fc8zkiq6mav3n4jiiffr-qtbase-5.15.12/lib:/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/home/runner/FAQ-Langchain/poppler-23.09.0/build:/nix/store/nxz7xvlvf88pkrlkxcn1nbkjzgibvyc4-lcms2-2.16/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib:"
           NEW_RPATH "/nix/store/qpk85xnnx7w7fc8zkiq6mav3n4jiiffr-qtbase-5.15.12/lib:/nix/store/c9n99v77q5wrk7dxr4xi16bn1l4cglly-freetype-2.13.2/lib:/nix/store/nxz7xvlvf88pkrlkxcn1nbkjzgibvyc4-lcms2-2.16/lib:/nix/store/qmzkb4rxywpkh4h81ryw7rlpmc6w4zwj-gpgme-1.23.2/lib:/nix/store/lja3blbngvaiik9bxifdlypilh4glzhw-openjpeg-2.5.2/lib")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/runner/FAQ-Langchain/poppler-23.09.0/build/qt5/src/libpoppler-qt5.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/poppler/qt5" TYPE FILE FILES
    "/home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src/poppler-qt5.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src/poppler-link.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src/poppler-annotation.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src/poppler-form.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src/poppler-optcontent.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src/poppler-page-transition.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/qt5/src/poppler-media.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/qt5/src/poppler-export.h"
    "/home/runner/FAQ-Langchain/poppler-23.09.0/build/qt5/src/poppler-version.h"
    )
endif()

