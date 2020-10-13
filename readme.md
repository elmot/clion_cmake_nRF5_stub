How to convert a standard nRF5 SDK example into a CLion-compatible CMake project
======
1. File structure
   + Create a project folder
   + Copy `main.c` -> `src/main.c`, `Makefile`->`Makefile.txt`, `config/` ->`config/`, `name.ld` files
   from the example folder
1. Templates   
   + Copy templates`SDK_NRF5.cmake.template.txt` -> `SDK_NRF5.cmake`,
   `CMakeLists.template.txt` -> `CMakeLists.txt`
   + Go through all `Todo` comments in those two files and fill up the information. 
      Use `TODO` tool window for that
1. CLion settings
   + Open `File` -> `Settings` -> `Build, Execution, Deployment` -> `Toolchains` and 
   setup a toolchain out of `MinGW` and `arm-none-eabi-gcc`
   + Right-click CMakeLists.txt and select `Load CMake project`
   + Open `File` -> `Settings` -> `Build, Execution, Deployment` -> `CMake`, create desired profiles
   and and set correct toolchain
   + Select `copy_sdk_headers` run configuration and build it 
   + Reset CMake caches, wait until indexing is done  
   + Create a run configuration of type "Embedded GDB Server" with parameters:
      * Name: `flash_debug`
      * Target: `flash`
      * Executable `<project_name>.elf`
      * Download Executable: `Never`
      * 'target remote' args: `tcp::2331`
      * GDB Server: path to `JLinkGDBServerCL` executable
      * GDB ServerArgs: `-device <device name> -strict -timeout 0 -nogui -if swd -s -silent`

        Note: For nRF52840 MCU device name is `nRF52840_xxAA` 
1. Flash and debug
   + Select `erase` run configuration and press ***Build***
   + Select `flash_softdevice` run configuration and press ***Build***
   + Select `flash_debug` run configuration and press ***Debug***
