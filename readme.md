How to convert a standard nRF5 SDK example into a CLion-compatible CMake project
======

1. Create a project folder and `cd` there
1. Download content of this repository to the project folder
    + `git clone --depth=1 https://github.com/elmot/clion_cmake_nRF5_stub.git .`
    + Delete `.git` folder
1. Copy files from the example to the project folder
    + `main.c` -> `src/main.c`
    + `Makefile`->`Makefile.txt`
    + `config/` ->`config/`
    + `<some_name>.ld` -> `<some_name>.ld`
1. Open the project with CLion
1. Go through all `Todo` comments in those two files and fill up the information. Use `TODO` tool window for that
1. CLion settings
    + Open `File` -> `Settings` -> `Build, Execution, Deployment` -> `Toolchains` and setup a toolchain out of `MinGW`
      and `arm-none-eabi-gcc`
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