message(STATUS "Copying header files from ${SDK_ROOT}...")
file (REMOVE_RECURSE ${SDK_HEADER_ROOT})
file (COPY ${SDK_ROOT}/ DESTINATION ${SDK_HEADER_ROOT} FILES_MATCHING PATTERN *.h)
message(STATUS "Header files copied")
