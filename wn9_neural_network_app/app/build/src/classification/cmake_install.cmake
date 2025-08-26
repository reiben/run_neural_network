# Install script for directory: /opt/my_run_neural_network/app/src/classification

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
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
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/opt/my_run_neural_network/app/libs/classification/libclassification.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/opt/my_run_neural_network/app/libs/classification/libclassification.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/opt/my_run_neural_network/app/libs/classification/libclassification.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/opt/my_run_neural_network/app/libs/classification/libclassification.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/opt/my_run_neural_network/app/libs/classification" TYPE MODULE FILES "/opt/my_run_neural_network/app/build/src/classification/libclassification.so")
  if(EXISTS "$ENV{DESTDIR}/opt/my_run_neural_network/app/libs/classification/libclassification.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/opt/my_run_neural_network/app/libs/classification/libclassification.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/opt/my_run_neural_network/app/libs/classification/libclassification.so"
         OLD_RPATH "/opt/opensdk/common/platform/wn9/lib:/opt/opensdk/common/product/wn9/lib:/opt/opensdk/common/product/wn9/3rd_party/lib:/opt/my_run_neural_network/app/libs:/opt/opensdk/common/product/wn9/lib/npu_api/libs:/opt/my_run_neural_network/app/libs/app_dispatcher:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/opt/my_run_neural_network/app/libs/classification/libclassification.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/opt/my_run_neural_network/app/libs/classification/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/opt/my_run_neural_network/app/libs/classification" TYPE DIRECTORY FILES "/opt/my_run_neural_network/app/src/classification/manifests/" FILES_MATCHING REGEX "/[^/]*manifest\\.json$")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/opt/my_run_neural_network/app/res/models/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/opt/my_run_neural_network/app/res/models" TYPE DIRECTORY FILES "/opt/my_run_neural_network/app/src/classification/manifests/" FILES_MATCHING REGEX "/[^/]*instance[^/]*\\.json$" REGEX "/[^/]*attribute[^/]*\\.json$")
endif()

