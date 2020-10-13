How to convert a standard nRF5 SDK example into a CLion-compatible CMake project
======
1. File structure
   1. Create a project folder
   1. Copy `main.c` -> `src/main.c`, `Makefile`->`Makefile.txt`, `config/` ->`config/`, `name.ld` files
   from the example folder
1. Templates   
   1. Copy templates`SDK_NRF5.cmake.template.txt` -> `SDK_NRF5.cmake`,
   `CMakeLists.template.txt` -> `CMakeLists.txt`
   1. Copy example `flash.xml` -> `.idea/runConfigurations/flash.xml`   
   1. Go through all `Todo` comments in those two files and fill up the information. 
      Use `TODO` tool window for that
1. CLion settings
   1. Open `File` -> `Settings` -> `Build, Execution, Deployment` -> `Toolchains` and 
   setup a toolchain out of `MinGW` and `arm-none-eabi-gcc`
   1. Right-click CMakeLists.txt and select `Load CMake project`
   1. Open `File` -> `Settings` -> `Build, Execution, Deployment` -> `CMake`, create desired profiles
   and and set correct toolchain
   1. Reset CMake caches, wait until indexing is done  
1. Standard Run Configuration settings for nRF52840 `-device nRF52840_xxAA -strict -timeout 0 -nogui -if swd -speed 20000 -s -silent` 