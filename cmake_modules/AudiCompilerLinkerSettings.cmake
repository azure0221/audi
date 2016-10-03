INCLUDE(YACMACompilerLinkerSettings)

# Setup the C++14 flag.
if(YACMA_COMPILER_IS_CLANGXX OR YACMA_COMPILER_IS_INTELXX OR YACMA_COMPILER_IS_GNUCXX)
	message(STATUS "Enabling the '-std=gnu++14' flag.")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++14")
endif()

# Setup the CXX flags from YACMA.
YACMA_SETUP_CXX_FLAGS()
