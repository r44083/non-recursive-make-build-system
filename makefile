include header.mk

OBJ :=
ALL_LIBDIR :=
ALL_LIB :=
ALL_LINKED_OBJ :=

define INCLUDE_MODULE
$(eval include $(module)/makefile)
$(eval OBJ += $(patsubst %.c,$(OBJDIR)/$(module)/%.o,$(filter %.c,$(SRC))) \
	$(patsubst %.cpp,$(OBJDIR)/$(module)/%.o,$(filter %.cpp,$(SRC))) \
	$(patsubst %.s,$(OBJDIR)/$(module)/%.o,$(filter %.s,$(SRC))) \
	$(patsubst %.S,$(OBJDIR)/$(module)/%.o,$(filter %.S,$(SRC))) \
)
$(eval ALL_LIBDIR += $(addprefix -L$(module)/,$(LIBDIR)))
$(eval ALL_LIB += $(addprefix -l,$(LIB)))
$(eval ALL_LINKED_OBJ += $(addprefix $(module)/,$(LINKED_OBJ)))
endef

# Include module and save its SRC.o to OBJ for future linking (repeat for each module)
$(foreach module,$(MODULES),$(eval $(call INCLUDE_MODULE,$(module))))

ALL_LIBDIR := $(strip $(ALL_LIBDIR))
ALL_LIB := $(strip $(ALL_LIB))

define COMPILE_MODULE
	+$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory -C $(module)
	
endef

.PHONY: all clean

all:
	$(foreach module,$(MODULES),$(call COMPILE_MODULE,$(module)))
	+$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory $(BIN)
ifeq ($(OS),Windows_NT)
	$(SIZE) $(BIN).exe
else
	$(SIZE) $(BIN)
endif

clean:
	$(call RMDIR,$(OUTDIR))

$(BIN): $(ALL_LINKED_OBJ) $(OBJ)
	@$(call MKDIR,$(@D))
ifeq ($(ALL_LIB),)
	$(LD) $(LDFLAGS) $^ -o $@
else
	$(LD) $(LDFLAGS) $^ $(ALL_LIBDIR) -Wl,--start-group $(ALL_LIB) -Wl,--end-group -o $@
endif