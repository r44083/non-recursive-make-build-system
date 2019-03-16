include header.mk

define INCLUDE_MODULE
$(eval include $(module)/makefile)
$(eval ALL_OBJ += $(patsubst $(OBJDIR)/%.o,$(OBJDIR)/$(module)/%.o,$(OBJ)))
$(eval ALL_LIBDIR += $(addprefix -L$(module)/,$(LIBDIR)))
$(eval ALL_LIB += $(addprefix -l,$(LIB)))
$(eval ALL_LINKED_OBJ += $(addprefix $(module)/,$(LINKED_OBJ)))
endef

define COMPILE_MODULE
	@$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory -C $(module)
	
endef

define COMPILE_MODULE
	+$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory -C $(module)
	
endef

# Collect prerequisites from modules for linkage
$(foreach module,$(MODULES),$(call INCLUDE_MODULE,$(module)))
ALL_LIB := $(strip $(ALL_LIB))

all:
	$(foreach module,$(MODULES),$(call COMPILE_MODULE,$(module)))
	@$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory $(BIN)
ifeq ($(OS),Windows_NT)
	$(SIZE) $(BIN).exe
else
	$(SIZE) $(BIN)
endif

clean:
	$(call RMDIR,$(OUTDIR))

$(BIN): $(ALL_OBJ) $(ALL_LINKED_OBJ)
	@$(call MKDIR,$(@D))
ifeq ($(ALL_LIB),)
	$(LD) $(LDFLAGS) $^ -o $@
else
	$(LD) $(LDFLAGS) $^ $(ALL_LIBDIR) -Wl,--start-group $(ALL_LIB) -Wl,--end-group -o $@
endif