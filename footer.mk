OBJ := $(patsubst %.c, $(OBJDIR)/%.o,$(filter %.c,$(SRC)))
OBJ += $(patsubst %.cpp, $(OBJDIR)/%.o,$(filter %.cpp,$(SRC)))
OBJ += $(patsubst %.s, $(OBJDIR)/%.o,$(filter %.s,$(SRC)))
OBJ += $(patsubst %.S, $(OBJDIR)/%.o,$(filter %.S,$(SRC)))

INC := $(addprefix -I,$(strip $(GLOBAL_INC) $(INC)))
DEF := $(addprefix -D,$(strip $(GLOBAL_DEF) $(DEF)))
C_CPP_FLAGS := $(strip $(GLOBAL_C_CPP_FLAGS) $(C_CPP_FLAGS))
CFLAGS := $(strip $(GLOBAL_CFLAGS) $(CFLAGS))
CPPFLAGS := $(strip $(GLOBAL_CPPFLAGS) $(CPPFLAGS))
AFLAGS := $(strip $(GLOBAL_AFLAGS) $(AFLAGS))

.PHONY: all clean

all: $(OBJ)

clean:
	if exist "$(OBJDIR)" rmdir /s /q "$(OBJDIR)"

$(OBJDIR)/%.o: %.c
	@if not exist "$(@D)" mkdir "$(@D)"
	$(CC) $(DEF) $(INC) $(C_CPP_FLAGS) $(CFLAGS) -c $^ -o $@

$(OBJDIR)/%.o: %.cpp
	@if not exist "$(@D)" mkdir "$(@D)"
	$(CPP) $(DEF) $(INC) $(C_CPP_FLAGS) $(CPPFLAGS) -c $^ -o $@

$(OBJDIR)/%.o: %.s %.S
	@if not exist "$(@D)" mkdir "$(@D)"
	$(AS) $(DEF) $(INC) $(AFLAGS) -c $^ -o $@
