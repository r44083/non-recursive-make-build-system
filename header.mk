# Absolute path to the root dir
ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ROOT := $(patsubst %/,%,$(ROOT))

# Relative path from the module dir to the root dir
REL_BACK_PATH := $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
REL_BACK_PATH := $(patsubst %/,%,$(REL_BACK_PATH))

# Relative path to the module dir
REL_PATH := $(patsubst $(ROOT)%,%,$(CURDIR))

OUTDIR := $(REL_BACK_PATH)/out
OBJDIR := $(OUTDIR)/obj$(REL_PATH)
BINDIR := $(OUTDIR)/bin

BIN := $(BINDIR)/$(notdir $(CURDIR))

CC := gcc
LD := gcc
CPP := g++
GDB := gdb
SIZE := size

GLOBAL_INC :=
GLOBAL_DEF :=
GLOBAL_C_CPP_FLAGS := -O0 -g3 -Wall
GLOBAL_CFLAGS := -std=c99
GLOBAL_CPPFLAGS := -std=c++17
GLOBAL_AFLAGS :=
LDFLAGS :=


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
