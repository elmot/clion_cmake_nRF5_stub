#Todo This file to be filled up with long list of includes and source files, as well as utility switches and defines
#Todo That may be borrowed from standard nRF SDK5 example Makefile
#Todo do not forget to remove end-of-line backslashes and replace round braces with curvy ones
#Todo Do not forget:
#Todo    - remove end-of-line backslashes
#Todo    - replace $(SDK_ROOT) -> ${SDK_ROOT}
#Todo    - throw away config directory name
#Todo    - throw away project-specific files names
include_directories(
        #[[todo list SDK include directories here]]
)

file(GLOB SDK_SOURCES
        #[[todo list SDK include directories here]]
)

#[[Todo list of defined symbols]]
add_definitions(-DSOFTDEVICE_PRESENT)

#[[Todo list of compiler switches]]
add_compile_options(-mcpu=cortex-m4 -mthumb -mthumb-interwork -mabi=aapcs)
add_compile_options(-ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin -fshort-enums)
add_compile_options(-Wall -Werror)
add_compile_options(-MP -MD)

#[[Todo list of linker switches]]
add_link_options(-mcpu=cortex-m4 -mthumb -mthumb-interwork -mabi=aapcs)
add_link_options(-mfloat-abi=hard -mfpu=fpv4-sp-d16)
add_link_options(-Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map)
add_link_options(-T ${LINKER_SCRIPT} -L${SDK_ROOT}/modules/nrfx/mdk --specs=nano.specs)
add_link_options(-lc -lnosys -lm)

