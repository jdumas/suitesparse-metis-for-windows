################################################################################
#
# \file      cmake/FindMKL.cmake
# \author    J. Bakosi
# \copyright 2012-2015, Jozsef Bakosi, 2016, Los Alamos National Security, LLC.
# \brief     Find the Math Kernel Library from Intel
# \date      Thu 26 Jan 2017 02:05:50 PM MST
#
################################################################################

# Find the Math Kernel Library from Intel
#
#  MKL_FOUND - System has MKL
#  MKL_INCLUDE_DIRS - MKL include files directories
#  MKL_LIBRARIES - The MKL libraries
#  MKL_COMPILE_OPTIONS - Compilation flags to use with MKL
#  MKL_INTERFACE_LIBRARY - MKL interface library
#  MKL_SEQUENTIAL_LAYER_LIBRARY - MKL sequential layer library
#  MKL_CORE_LIBRARY - MKL core library
#
#  The environment variables MKLROOT and INTEL are used to find the library.
#  Everything else is ignored. If MKL is found "-DMKL_ILP64" is added to
#  CMAKE_C_FLAGS and CMAKE_CXX_FLAGS.
#
#  Example usage:
#
#  find_package(MKL)
#  if(MKL_FOUND)
#    target_link_libraries(TARGET ${MKL_LIBRARIES})
#  endif()

# If already in cache, be silent
if(MKL_INCLUDE_DIRS
   AND MKL_LIBRARIES
   AND MKL_INTERFACE_LIBRARY
   AND MKL_SEQUENTIAL_LAYER_LIBRARY
   AND MKL_CORE_LIBRARY)
  set(MKL_FIND_QUIETLY TRUE)
endif()

if(NOT MKL_SHARED_LIBS)
  if(WIN32)
      if(CMAKE_SIZEOF_VOID_P EQUAL 8)
          set(INT_LIB "mkl_intel_lp64.lib")
      else()
          set(INT_LIB "mkl_intel_c.lib")
      endif()
      set(SEQ_LIB "mkl_sequential.lib")
      set(THR_LIB "mkl_intel_thread.lib")
      set(COR_LIB "mkl_core.lib")
  else()
      set(INT_LIB "libmkl_intel_lp64.a")
      set(SEQ_LIB "libmkl_sequential.a")
      set(THR_LIB "libmkl_intel_thread.a")
      set(COR_LIB "libmkl_core.a")
  endif()
else()
  if(WIN32)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(INT_LIB "mkl_intel_lp64_dll.lib")
    else()
      set(INT_LIB "mkl_intel_c_dll.lib")
    endif()
    set(SEQ_LIB "mkl_sequential_dll.lib")
    set(THR_LIB "mkl_intel_thread_dll.lib")
    set(COR_LIB "mkl_core_dll.lib")
  else()
    set(INT_LIB "libmkl_intel_lp64.so")
    set(SEQ_LIB "libmkl_sequential.so")
    set(THR_LIB "libmkl_intel_thread.so")
    set(COR_LIB "libmkl_core.so")
  endif()
endif()

find_path(MKL_INCLUDE_DIR NAMES mkl.h HINTS $ENV{MKLROOT}/include)

find_library(MKL_INTERFACE_LIBRARY
             NAMES ${INT_LIB}
             PATHS $ENV{MKLROOT}/lib
                   $ENV{MKLROOT}/lib/intel64
                   $ENV{INTEL}/mkl/lib/intel64
             NO_DEFAULT_PATH)

find_library(MKL_SEQUENTIAL_LAYER_LIBRARY
             NAMES ${SEQ_LIB}
             PATHS $ENV{MKLROOT}/lib
                   $ENV{MKLROOT}/lib/intel64
                   $ENV{INTEL}/mkl/lib/intel64
             NO_DEFAULT_PATH)

find_library(MKL_CORE_LIBRARY
             NAMES ${COR_LIB}
             PATHS $ENV{MKLROOT}/lib
                   $ENV{MKLROOT}/lib/intel64
                   $ENV{INTEL}/mkl/lib/intel64
             NO_DEFAULT_PATH)

set(MKL_INCLUDE_DIRS ${MKL_INCLUDE_DIR})
set(MKL_LIBRARIES ${MKL_INTERFACE_LIBRARY} ${MKL_SEQUENTIAL_LAYER_LIBRARY} ${MKL_CORE_LIBRARY})

if(MKL_INCLUDE_DIR
   AND MKL_INTERFACE_LIBRARY
   AND MKL_SEQUENTIAL_LAYER_LIBRARY
   AND MKL_CORE_LIBRARY)

  if(NOT DEFINED ENV{CRAY_PRGENVPGI}
     AND NOT DEFINED ENV{CRAY_PRGENVGNU}
     AND NOT DEFINED ENV{CRAY_PRGENVCRAY}
     AND NOT DEFINED ENV{CRAY_PRGENVINTEL})
    set(ABI "-m64")
  endif()

  set(MKL_COMPILE_OPTIONS "-DMKL_ILP64 ${ABI}")

else()

  set(MKL_INCLUDE_DIRS "")
  set(MKL_LIBRARIES "")
  set(MKL_COMPILE_OPTIONS "")
  set(MKL_INTERFACE_LIBRARY "")
  set(MKL_SEQUENTIAL_LAYER_LIBRARY "")
  set(MKL_CORE_LIBRARY "")

endif()

# Handle the QUIETLY and REQUIRED arguments and set MKL_FOUND to TRUE if all
# listed variables are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MKL
                                  DEFAULT_MSG
                                  MKL_LIBRARIES
                                  MKL_COMPILE_OPTIONS
                                  MKL_INCLUDE_DIRS
                                  MKL_INTERFACE_LIBRARY
                                  MKL_SEQUENTIAL_LAYER_LIBRARY
                                  MKL_CORE_LIBRARY)

mark_as_advanced(MKL_INCLUDE_DIRS
                 MKL_LIBRARIES
                 MKL_COMPILE_OPTIONS
                 MKL_INTERFACE_LIBRARY
                 MKL_SEQUENTIAL_LAYER_LIBRARY
                 MKL_CORE_LIBRARY)
