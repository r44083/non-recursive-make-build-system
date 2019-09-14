include config.mk

define INCLUDE_MODULE
$(eval include $(1)/makefile)
$(eval ALL_OBJ += $(patsubst $(OBJDIR)/%.o,$(OBJDIR)/$(1)/%.o,$(OBJ)))
$(eval ALL_LIBDIR += $(addprefix -L$(1)/,$(LIBDIR)))
$(eval ALL_LIB += $(addprefix -l,$(LIB)))
$(eval ALL_LINKED_OBJ += $(addprefix $(1)/,$(LINKED_OBJ)))
endef

define BUILD_MODULE
@echo --- Build "$(1)":
@$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory -C $(1)

endef

define CLEAN_MODULE
@echo --- Clean "$(1)":
@$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory -C $(1) clean

endef

# Collect prerequisites from modules
$(foreach module,$(MODULES),$(eval $(call INCLUDE_MODULE,$(module))))
ALL_LIBDIR := $(strip $(ALL_LIBDIR))
ALL_LIB := $(sort $(ALL_LIB))
ALL_LINKED_OBJ := $(strip $(ALL_LINKED_OBJ))

all:
	$(foreach module,$(MODULES),$(call BUILD_MODULE,$(module)))
	@$(MAKE) -j $(NUMBER_OF_PROCESSORS) --no-print-directory $(BIN)
ifeq ($(OS),Windows_NT)
	$(SIZE) $(BIN).exe
else
	$(SIZE) $(BIN)
endif

clean:
	$(foreach module,$(MODULES),$(call CLEAN_MODULE,$(module)))
	$(call RMDIR,$(BUILDDIR))

$(BIN): $(ALL_OBJ) $(ALL_LINKED_OBJ)
	@echo --- Linking "$(BIN)":
	$(call MKDIR,$(@D))
ifeq ($(ALL_LIB),)
	$(LD) $(LDFLAGS) $^ -o $@
else
	$(LD) $(LDFLAGS) $^ $(ALL_LIBDIR) -Wl,--start-group $(ALL_LIB) -Wl,--end-group -o $@
endif
