-include header.mk

MODULES := src
MODULES += src/a
MODULES += src/b
MODULES += src/b/c

OBJ :=
ALL_LIBDIR :=
ALL_LIB :=
ALL_LINKED_OBJ :=

define INCLUDE_MODULE
$(eval include $(module)/makefile)
$(eval OBJ += $(patsubst %.c,$(OBJDIR)/$(module)/%.o,$(filter %.c,$(SRC))))
$(eval OBJ += $(patsubst %.cpp,$(OBJDIR)/$(module)/%.o,$(filter %.cpp,$(SRC))))
$(eval OBJ += $(patsubst %.s,$(OBJDIR)/$(module)/%.o,$(filter %.s,$(SRC))))
$(eval OBJ += $(patsubst %.S,$(OBJDIR)/$(module)/%.o,$(filter %.S,$(SRC))))
$(eval ALL_LIBDIR += $(addprefix -L$(module)/,$(LIBDIR)))
$(eval ALL_LIB += $(addprefix -l,$(LIB)))
$(eval ALL_LINKED_OBJ += $(addprefix $(module)/,$(LINKED_OBJ)))
endef
# Include module and save its SRC.o to OBJ for future linking (repeat for each module)
$(foreach module,$(MODULES),$(call INCLUDE_MODULE,$(module)))

LDFLAGS += $(strip $(ALL_LIBDIR))
ALL_LIB := $(strip $(ALL_LIB))

ifdef ALL_LIB
LDFLAGS += -Wl,--start-group $(ALL_LIB) -Wl,--end-group
endif

define COMPILE_MODULE
	+$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory -C $(module)
	
endef

.PHONY: all clean

all:
	$(foreach module,$(MODULES),$(call COMPILE_MODULE,$(module)))
	+$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory $(BIN)
	$(SIZE) $(BIN).exe

clean:
	if exist "$(OUTDIR)" rmdir /s /q "$(OUTDIR)"

$(BIN): $(ALL_LINKED_OBJ) $(OBJ)
	@if not exist "$(@D)" mkdir "$(@D)"
	$(LD) $(LDFLAGS) $^ -o $@
