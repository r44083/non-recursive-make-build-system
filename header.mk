MODULES := src
MODULES += src/a
MODULES += src/b
MODULES += src/b/c

ROOT := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

GLOBAL_INC :=
GLOBAL_DEF :=
GLOBAL_C_CPP_FLAGS := -O0 -g3 -Wall
GLOBAL_CFLAGS := -std=c99
GLOBAL_CPPFLAGS := -std=c++17
GLOBAL_AFLAGS :=
LDFLAGS :=

CC := gcc
LD := gcc
CPP := g++
GDB := gdb
SIZE := size

OUTDIR := $(ROOT)/out
# Relative path to module object folder
OBJDIR := $(OUTDIR)/obj$(patsubst $(abspath $(ROOT))%,%,$(CURDIR))
BINDIR := $(OUTDIR)/bin

BIN := $(BINDIR)/$(notdir $(CURDIR))

ifeq ($(OS),Windows_NT)
define MKDIR
	if not exist "$(1)" mkdir "$(1)"
endef
define RMDIR
	if exist "$(1)" rmdir /s /q "$(1)"
endef
else
define MKDIR
	mkdir -p $(1)
endef
define RMDIR
	rm -rf $(1)
endef
endif
