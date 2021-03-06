if(UNIX)
# On unix platforms, we set the rpath of the pyaudi libraries
# to the lib subdirectory of the install prefix. This allows
# to install pyaudi in nonstandard locations (e.g., ~/.local)
# without having to muck around with library search paths.
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
endif()

# The name of the BP target to link to depends on the Python version.
if(${PYTHON_VERSION_MAJOR} EQUAL 2)
set(PYAUDI_BP_TARGET "Boost::python")
else()
set(PYAUDI_BP_TARGET "Boost::python3")
endif()

# Boost.Python version 1.64 (and possibly later?) has issues with default hidden visibility.
if(${Boost_MAJOR_VERSION} GREATER 1 OR (${Boost_MAJOR_VERSION} EQUAL 1 AND ${Boost_MINOR_VERSION} GREATER 63))
list(FIND AUDI_CXX_FLAGS_DEBUG "-fvisibility=hidden" _PYAUDI_HAS_VHIDDEN)
if (NOT ${_PYAUDI_HAS_VHIDDEN} EQUAL -1)
	message(STATUS "Removing the '-fvisibility=hidden' flag for Boost.Python > 1.63.")
	list(REMOVE_ITEM AUDI_CXX_FLAGS_DEBUG "-fvisibility=hidden")
	list(REMOVE_ITEM AUDI_CXX_FLAGS_RELEASE "-fvisibility=hidden")
endif()
endif()

# Setup of the header-only pyaudi library.
add_library(pyaudi INTERFACE)
target_link_libraries(pyaudi INTERFACE ${PYAUDI_BP_TARGET} Boost::disable_autolinking YACMA::PythonModule Audi::audi ${MPFR_LIBRARIES})
target_include_directories(pyaudi INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include/pyaudi> $<INSTALL_INTERFACE:include>)

# Setup of the pyaudi core module.
YACMA_PYTHON_MODULE(core core.cpp docstrings.cpp)
target_link_libraries(core PRIVATE ${PYAUDI_BP_TARGET} pyaudi ${MPFR_LIBRARIES})
target_compile_options(core PRIVATE "$<$<CONFIG:DEBUG>:${AUDI_CXX_FLAGS_DEBUG}>" "$<$<CONFIG:RELEASE>:${AUDI_CXX_FLAGS_RELEASE}>")
set_property(TARGET core PROPERTY CXX_STANDARD 11)
set_property(TARGET core PROPERTY CXX_STANDARD_REQUIRED YES)
set_property(TARGET core PROPERTY CXX_EXTENSIONS NO)

# Setup the installation path.
set(PYAUDI_INSTALL_PATH "${YACMA_PYTHON_MODULES_INSTALL_PATH}/pyaudi")
install(TARGETS core
RUNTIME DESTINATION ${PYAUDI_INSTALL_PATH}
LIBRARY DESTINATION ${PYAUDI_INSTALL_PATH}
)

# Add the Python files.
install(FILES __init__.py _version.py test.py DESTINATION ${PYAUDI_INSTALL_PATH})




































