#
# C++ Makefile template
#


BIN_NAME     = a.out
# yes / no
IS_LIBRARY   = no

SRC_DIR      = .
CPP_FILES    = $(shell ls $(SRC_DIR)/*.cpp)
OBJECT_FILES = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.o,$(CPP_FILE)))
DEP_FILES    = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.d,$(CPP_FILE)))

CXXFLAGS     = -g
LDFLAGS      =

ECHO         = $(shell which echo)


all: $(DEP_FILES)
	$(MAKE) build


-include $(DEP_FILES)


build: $(BIN_NAME)


clean:
	@echo "========= CLEANING ========="
	rm -f $(OBJECT_FILES) $(BIN_NAME)
	@echo


rebuild:
	$(MAKE) clean
	$(MAKE) build


deps: $(DEP_FILES)


clean-deps:
	rm -f $(DEP_FILES)


$(BIN_NAME): $(OBJECT_FILES)
ifeq ($(IS_LIBRARY),yes)
	@echo "========= LINKING LIBRARY $@ ========="
	$(AR) -r $@ $^
else
	@echo "========= LINKING EXECUTABLE $@ ========="
	$(CXX) $(CXXFLAGS) -o $@ $^ 
endif
	@echo


.PHONY: all build clean rebuild deps clean-deps


%.d: %.cpp
	@$(ECHO) -n "$(SRC_DIR)/" > $@
	@$(CXX) $(CXXFLAGS) -MM $< >> $@


