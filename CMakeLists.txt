cmake_minimum_required(VERSION 3.17)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)

#sdk settings
set(SDK_ROOT ${CMAKE_SOURCE_DIR}/../nRF5_SDK_17.0.2_d674dde) #[[todo verify if it's correct]]
set(SDK_HEADER_ROOT ${CMAKE_SOURCE_DIR}/sdk_include)

# project settings
project(<project_name> #[[todo]] C CXX ASM)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 99)
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/file.ld) #[[todo]]
set(SOFT_DEVICE_FILE ${SDK_ROOT}/components/softdevice/s140/hex/s140_nrf52_7.2.0_softdevice.hex) #[[todo verify if it's correct]]

include(verify_tools.cmake)

include(SDK_NRF5.cmake)

get_filename_component(SOFT_DEVICE_SHORT_NAME ${SOFT_DEVICE_FILE} NAME)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    message(STATUS "Maximum optimization for speed")
    add_compile_options(-Ofast)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    message(STATUS "Maximum optimization for speed, debug info included")
    add_compile_options(-Ofast -g3)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    message(STATUS "Maximum optimization for size")
    add_compile_options(-Os)
else ()
    message(STATUS "No optimization, max debug info included")
    add_compile_options(-O0 -g3)
endif ()

add_executable(${PROJECT_NAME}.elf)
target_sources(${PROJECT_NAME}.elf PRIVATE  ${LINKER_SCRIPT} ${SDK_SOURCES} src/main.c)
target_include_directories(${PROJECT_NAME}.elf PRIVATE ${CMAKE_SOURCE_DIR}/config ${NRF5_SDK_HEADERS})
target_compile_definitions(${PROJECT_NAME}.elf PRIVATE ${PROJECT_DEFINITIONS})

target_compile_options(${PROJECT_NAME}.elf PRIVATE ${PROJECT_COMMON_BUILD_OPTIONS} ${PROJECT_COMPILE_OPTIONS})

target_link_options(${PROJECT_NAME}.elf PRIVATE
        ${PROJECT_COMMON_BUILD_OPTIONS}
        -Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map
        -T ${LINKER_SCRIPT} -L${SDK_ROOT}/modules/nrfx/mdk --specs=nano.specs
        -lc -lnosys -lm
        )

# uncomment to mitigate c++17 absolute addresses warnings
#target_compile_options(${PROJECT_NAME}.elf PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wno-register>)

#Custom defines - enable debug output via RTT
#target_compile_definitions(${PROJECT_NAME}.elf PRIVATE -DNRF_LOG_BACKEND_RTT_ENABLED=1 -DDEBUG)

set(HEX_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE}
Building ${BIN_FILE}")

add_custom_target(erase
        COMMAND ${NRFJPROG} -f nrf52 --eraseall
        COMMENT "Erase flash")

add_custom_target(flash_softdevice
        COMMAND ${NRFJPROG} -f nrf52 --program ${SOFT_DEVICE_FILE} --sectorerase
        COMMAND ${NRFJPROG} -f nrf52 --reset
        COMMENT "Flashing softdevice ${SOFT_DEVICE_SHORT_NAME}")

add_custom_target(flash
        COMMAND ${NRFJPROG} -f nrf52 --program ${HEX_FILE} --sectorerase
        COMMAND ${NRFJPROG} -f nrf52 --reset
        DEPENDS ${PROJECT_NAME}.elf
        COMMENT "Flashing binary ${PROJECT_NAME}.hex")

add_custom_target(sdk_config
        COMMAND java -jar ${SDK_ROOT}/external_tools/cmsisconfig/CMSIS_Configuration_Wizard.jar ${CMAKE_SOURCE_DIR}/config/sdk_config.h
        COMMENT "Configuring CMSIS")

if (NOT EXISTS ${SDK_HEADER_ROOT}/components/libraries/util/sdk_common.h)
    execute_process(COMMAND ${CMAKE_COMMAND} -D SDK_ROOT=${SDK_ROOT} -D SDK_HEADER_ROOT=${SDK_HEADER_ROOT} -P ${CMAKE_SOURCE_DIR}/copy_headers.cmake)
endif ()
