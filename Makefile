# commands
SHELL         := bash
CC            := g++
INSTALL       := install
CP            := cp -p
RM            := rm
MKDIR         := mkdir -p -m 755
CHMOD         := chmod

# sources, and target
SRCDIR        := ./src
OBJDIR        := ./obj
SRC           := $(wildcard $(SRCDIR)/*.cpp)
OBJ           := $(addprefix $(OBJDIR)/,$(notdir $(SRC:.cpp=.o)))
BIN           := ./rodentIV
BOOKSDIR      := books
STYLESDIR     := personalities

# install paths
BASEDIR       := /usr/local
# BASEDIR       := /tmp/local
BINDIR        := $(BASEDIR)/bin
DATADIR       := $(BASEDIR)/share/rodentIV

# pre-proce   ssor & compiler
CPPFLAGS      := -DNDEBUG
CPPFLAGS      += -DBOOKSPATH=$(DATADIR)/$(BOOKSDIR)
CPPFLAGS      += -DPERSONALITIESPATH=$(DATADIR)/$(STYLESDIR)
#CPPFLAGS      += -DWRITEDEBUGFILE

CFLAGS        := -std=gnu++14
CFLAGS        += -O3
CFLAGS        += -g
CFLAGS        += -Wall
CFLAGS        += -Wextra
CFLAGS        += -march=native
CFLAGS        += -Wmissing-declarations
CFLAGS        += -Wno-unknown-pragmas			    # ignore "pragma warning"
# from orig Makefile, unsure...
CFLAGS        += -fno-rtti
CFLAGS        += -fprefetch-loop-arrays
#CFLAGS        += -pipe

# define the link options
LDFLAGS       := -lm					    # unused ?

# remove useless spaces
CPPFLAGS      := $(strip $(CPPFLAGS))
CFLAGS        := $(strip $(CFLAGS))
LDFLAGS       := $(strip $(LDFLAGS))

.PHONY: compile all clean cleanobj cleanall install uninstall help

compile: $(BIN)

$(BIN): $(OBJ)
	@echo "compiling $< -> $@."
	@$(CC) $(LDFLAGS) $^ -o $@

# build binary without symbols
release: LDFLAGS += -s
release: clean $(BIN)

$(OBJDIR):
	@echo creating $@ directory.
	@$(MKDIR) $@

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(OBJDIR)
	@echo "compiling $< -> $@."
	@$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

all: cleanall compile

clean:
	@echo cleaning binaries.
	@$(RM) -f $(BIN)
cleanobj:
	@echo cleaning obj...
	@$(RM) -rf $(OBJDIR)
cleanall: cleanobj clean

install:
	@echo installing rodendIV.
	@$(INSTALL) -d $(BINDIR) $(DATADIR)
	@$(CP) -a $(STYLESDIR) $(BOOKSDIR) $(DATADIR)

uninstall:
	@echo uninstalling rodendIV.
	@$(RM) -f $(BINDIR)/$(BIN)
	@$(RM) -rf $(DATADIR)

help:
	@echo "Available make targets"
	@echo ""
	@echo "  make [compile]   Build Rodent IV"
	@echo "  make all         Force re-Build."
	@echo "  make release     Build Rodent IV, release version"
	@echo
	@echo "  make clean       Clean binary"
	@echo "  make cleanobj    Clean objects"
	@echo "  make cleanall    Clean all"
	@echo
	@echo "  make install     Install Rodent IV (root required)"
	@echo "  make uninstall	  Uninstall Rodent IV (root required)"
