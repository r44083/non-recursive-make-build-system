MODULES := src \
	src/a\
	src/b \
	src/b/c

ROOT := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

OUTDIR := $(ROOT)/out
# Relative path to module object folder
OBJDIR := $(OUTDIR)/obj$(patsubst $(abspath $(ROOT))%,%,$(CURDIR))
BINDIR := $(OUTDIR)/bin

BIN := $(BINDIR)/$(notdir $(CURDIR))

GLOBAL_INC :=
GLOBAL_DEF :=
GLOBAL_C_CPP_FLAGS := -O0 -g3 -Wall
GLOBAL_CFLAGS := -std=c99
GLOBAL_CPPFLAGS := -std=c++17
GLOBAL_AFLAGS :=
LDFLAGS :=

CC := gcc
CPP := g++
AS := gcc -x assembler-with-cpp
LD := gcc
GDB := gdb
SIZE := size

ifeq ($(OS),Windows_NT)

define MKDIR
@if not exist "$(1)" mkdir "$(1)"

endef
define RMDIR
@if exist "$(1)" rmdir /s /q "$(1)"

endef
define RM
@del /q "$(1)" 2>nul

endef

else

define MKDIR
@mkdir -p "$(1)"

endef
define RMDIR
@rm -r "$(1)"

endef
define RM
@rm "$(1)"

endef

endif
