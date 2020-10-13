cmake_minimum_required(VERSION 3.17)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
# specify cross compilers and tools
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_AR arm-none-eabi-ar)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_OBJDUMP arm-none-eabi-objdump)
set(SIZE arm-none-eabi-size)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#sdk settings
set(SDK_ROOT ${CMAKE_SOURCE_DIR}/../nRF5_SDK_17.0.2_d674dde) #[[todo verify if it's correct]]
set(NRF_TOOLS "C:\\Program Files\\Nordic Semiconductor\\nrf-command-line-tools\\bin\\") #[[todo verify if it's correct]]

# project settings
project(<project_name> #[[todo]] C CXX ASM)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 99)
include_directories(${CMAKE_SOURCE_DIR}/config)
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/file.ld #[[todo]])
set(SOFT_DEVICE_FILE ${SDK_ROOT}/components/softdevice/s140/hex/s140_nrf52_7.2.0_softdevice.hex#[[todo verify if it's correct]])

# uncomment to mitigate c++17 absolute addresses warnings
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-register")

#Custom defines
#add_definitions(-DNRF_LOG_BACKEND_RTT_ENABLED=1 -DDEBUG)

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
    add_compile_options(-O3 -g3)
endif ()

add_executable(${PROJECT_NAME}.elf ${LINKER_SCRIPT} ${SDK_SOURCES}
        src/main.c)

set(HEX_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin)
        add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE}
Building ${BIN_FILE}")

add_custom_target(erase
        COMMAND ${NRF_TOOLS}/nrfjprog -f nrf52 --eraseall
        COMMENT "Erase flash")

add_custom_target(flash_softdevice
        COMMAND ${NRF_TOOLS}/nrfjprog -f nrf52 --program ${SOFT_DEVICE_FILE} --sectorerase
        COMMAND ${NRF_TOOLS}/nrfjprog -f nrf52 --reset
        COMMENT "Flashing softdevice ${SOFT_DEVICE_SHORT_NAME}")

add_custom_target(flash
        COMMAND ${NRF_TOOLS}/nrfjprog -f nrf52 --program ${HEX_FILE} --sectorerase
        COMMAND ${NRF_TOOLS}/nrfjprog -f nrf52 --reset
        DEPENDS ${PROJECT_NAME}.elf
        COMMENT "Flashing binary ${PROJECT_NAME}.hex")

add_custom_target(sdk_config
        COMMAND java -jar ${SDK_ROOT}/external_tools/cmsisconfig/CMSIS_Configuration_Wizard.jar ${CMAKE_SOURCE_DIR}/config/sdk_config.h
        COMMENT "Configuring CMSIS")

add_custom_target(copy_sdk_headers
        COMMAND ${CMAKE_COMMAND} -D SDK_ROOT=${SDK_ROOT} -D SDK_HEADER_ROOT=${SDK_HEADER_ROOT} -P ${CMAKE_SOURCE_DIR}/copy_headers.cmake
        )

