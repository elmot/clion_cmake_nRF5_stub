#Verify tools and various key files existence
if (NOT EXISTS ${NRFJPROG})
    message(FATAL_ERROR "nRF J-Link Programmer 'nrfjprog' is not found does not exists")
endif ()

if (NOT EXISTS ${LINKER_SCRIPT})
    message(FATAL_ERROR "Linker script ${LINKER_SCRIPT} does not exists")
endif ()

if (NOT EXISTS ${SDK_ROOT}/components/libraries/util/sdk_common.h)
    message(FATAL_ERROR "nRF5 SDK is not found at ${SDK_ROOT}")
endif ()

if (NOT EXISTS ${SOFT_DEVICE_FILE})
    message(FATAL_ERROR "Soft device binary ${SOFT_DEVICE_FILE} does not exists")
endif ()
