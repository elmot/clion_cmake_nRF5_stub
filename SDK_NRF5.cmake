#This file to be filled up with long list of includes and source files, as well as utility switches and defines
#That may be borrowed from standard nRF SDK5 example Makefile
#Do not forget:
#   - remove end-of-line backslashes
#   - replace $(SDK_ROOT) -> ${SDK_ROOT} for sources
#   - replace $(SDK_ROOT) -> ${SDK_HEADER_ROOT} for includes
#   - throw away config directory name
#   - throw away project-specific files names
set(NRF5_SDK_HEADERS
        #[[todo list SDK include directories here]]
)

set(SDK_SOURCES
        #[[todo list SDK source files here]]
)

set(PROJECT_DEFINITIONS
-DSOFTDEVICE_PRESENT
        #[[todo list of defined symbols]]
)

set(PROJECT_COMMON_BUILD_OPTIONS
#[[Todo list of switches for compiler and linker]]
-mcpu=cortex-m4 -mthumb -mthumb-interwork -mabi=aapcs
-mfloat-abi=hard -mfpu=fpv4-sp-d16
)

set(PROJECT_COMPILE_OPTIONS
#[[Todo list of linker switches]]
-ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin -fshort-enums
-Wall -Werror
)
