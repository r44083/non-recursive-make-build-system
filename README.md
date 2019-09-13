# Non-recursive make build system
Template with example of using painless non-recursive make build system.

## Existing project tree:
```
|- config.mk
|- makefile
+- src              << module src
   |- main.c
   |- makefile
   +- a             << module a
   |  |- a-1.c
   |  |- a-1.h
   |  |- a-2.c
   |  |- a-2.h
   |  |- makefile
   |  +- a-3
   |     |- a-3.c
   |     +- a-3.h
   +- b             << module b
      |- b-1.cpp
      |- b-1.hpp
      |- b-2.c
      |- b-2.h
      |- makefile
      +- c          << module c
         |- c-1.c
         |- c-1.h
         +- makefile
```

## Features:
+ Modular structure. Module is just subfolder with its own makefile. The module can also have its own subfolders.
+ Doesn't require additional enviromental variables (like ```TOPDIR```, ```ROOTDIR```, etc)
+ Handles header dependencies
+ Easy to use and configure
+ Run ```make``` or ```make clean``` in root folder to build/clean whole project
+ Run ```make``` or ```make clean``` in module folder to build/clean only this module
+ Cross-platform (Windows, Linux)

## How to use:
1. Run ```make``` in root folder to build project
2. Find build artifacts in ```out/bin``` folder
3. Find objects in ```out/obj``` folder
> If you need to add some specific build steps, do in under the ```all:``` target in module`s makefile

## How to add new module:
1. Create folder for new module in project
2. Copy-paste the module makefile to the root of new module folder.
> Be aware of relative path to the ```config.mk``` on top of module's makefile: path must be relative to the root of the project

3. Add path to the created module in ```MODULES``` variable in ```config.mk``` makefile:
```
MODULES := src \
    src/a \
    src/b \
    <path to new module>
```
