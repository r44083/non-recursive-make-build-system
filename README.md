# Recursive make build system
Template (example) of recursive make build system

## Existing project tree:
```
|- footer.mk
|- header.mk
|- makefile
+- src              << module main
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
      |- b-1.h
      |- b-2.c
      |- b-2.h
      |- makefile
      +- c          << module c
         |- c-1.c
         |- c-1.h
         +- makefile
```

## Features:
+ Modular structure. Module is just subfolder with its own makefile
+ Doesn't require additional enviromental variables (like ```TOPDIR```, ```ROOTDIR```, etc)
+ Easy to use and configure
+ Run ```make``` in root folder to build whole project and link it
+ Run ```make``` in module folder to compile it
+ Cross-platform (Windows, Linux)

## How to use:
1. Run ```make``` in root folder to build whole project and link it
2. Find objects in ```out/obj``` folder
3. Find artifacts in ```out/bin``` folder

## How to add new module:
1. Create folder for new modul in projct
2. Copy-paste the following makefile to the root of new module folder:
> Be aware of relative path in top and bottom "includes": path must be relative to the root of the project
```
-include ../header.mk

SRC :=
INC :=
DEF :=
C_CPP_FLAGS :=
CFLAGS :=
CPPFLAGS :=
AFLAGS :=

LIBDIR :=
LIB :=
LINKED_OBJ :=

-include ../footer.mk
```

3. Add path to the new module in ```MODULES``` variable in root makefile
```
MODULES := src
MODULES += src/a
MODULES += src/b
MODULES += <path to the new module>
```
