#
# C++ Makefile template
#


BIN_NAME     = a.out
# yes / no
IS_LIBRARY   = no

CPP_FILES    = $(shell ls *.cpp)
OBJECT_FILES = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.o,$(CPP_FILE)))
DEP_FILES    = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.d,$(CPP_FILE)))

CXXFLAGS     = -g
LDFLAGS      =


all: $(DEP_FILES)
	$(MAKE) build
	@echo X: $(CPP_FILES)
	@echo X: $(OBJECT_FILES)


-include $(DEP_FILES)


build: $(BIN_NAME)


clean:
	@echo "========= CLEANING ========="
	rm -f $(OBJECT_FILES) $(EXE_NAME)
	@echo


rebuild:
	$(MAKE) clean
	$(MAKE) build


deps: $(DEP_FILES)


clean-deps:
	rm -f $(DEP_FILES)


$(BIN_NAME): $(OBJECT_FILES)
ifeq ($(IS_LIBRARY),yes)
	@echo "========= LINKING EXECUTABLE $@ ========="
	$(AR) -r $@ $^
else
	@echo "========= LINKING LIBRARY $@ ========="
	$(CXX) $(CXXFLAGS) -o $@ $^ 
endif
	@echo


.PHONY: all build clean rebuild deps clean-deps


%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MM -o $@ $<


