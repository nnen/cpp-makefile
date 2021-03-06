#
# C++ Makefile template
#


BIN_NAME     = a.out
VERSION      = 0.1
# yes / no
IS_LIBRARY   = no

SRC_DIR      = .
CPP_FILES    = $(shell ls $(SRC_DIR)/*.cpp)
H_FILES      = $(shell ls $(SRC_DIR)/*.h)
OBJECT_FILES = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.o,$(CPP_FILE)))
DEP_FILES    = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.d,$(CPP_FILE)))

DOCS_ARCH    = $(BIN_NAME)-$(VERSION)-docs.html.tar.gz

UNAME       := $(shell uname)
CXXFLAGS     = -Wall -ggdb3 -O0
LDFLAGS      =
## Uncomment the block below if you need platform-specific linker flags.
#ifeq ($(UNAME),Darwin)
#	LDFLAGS += -framework jackmp
#else
#	LDFLAGS += $(shell pkg-config --libs jack)
#endif


ECHO         = $(shell which echo)


all: $(DEP_FILES)
	$(MAKE) build


-include $(DEP_FILES)


build: $(BIN_NAME)


clean:
	@echo "========= CLEANING =================================================="
	rm -f $(OBJECT_FILES) $(BIN_NAME)
	@echo


rebuild:
	@$(MAKE) clean
	@$(MAKE) build


deps: $(DEP_FILES)


clean-deps:
	rm -f $(DEP_FILES)


docs:
	@$(ECHO) "========= GENERATING DOCS ==========================================="
	doxygen
	# WARNING: The paths in the following command depend on settings in Doxyfile
	cd docs/html; tar -czf ../../$(DOCS_ARCH) ./*


clean-docs:
	@$(ECHO) "========= CLEANING DOCS ============================================="
	rm -fR docs/html


$(BIN_NAME): $(OBJECT_FILES)
ifeq ($(IS_LIBRARY),yes)
	@echo "========= LINKING LIBRARY $@ ========================================"
	$(AR) -r $@ $^
else
	@echo "========= LINKING EXECUTABLE $@ ====================================="
	$(CXX) $(LDFLAGS) $(CXXFLAGS) -o $@ $^ 
endif
	@echo


.PHONY: all build clean rebuild deps clean-deps docs clean-docs


%.d: %.cpp $(H_FILES)
	@$(ECHO) "Generating \"$@\"..."
	@$(ECHO) -n "$(SRC_DIR)/" > $@
	@$(CXX) $(CXXFLAGS) -MM $< >> $@


