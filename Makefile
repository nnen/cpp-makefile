#
# C++ Makefile template
#

EXE_NAME = a.out

CPP_FILES = $(shell ls *.cpp)
OBJECT_FILES = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.o,$(CPP_FILE)))
DEP_FILES = $(foreach CPP_FILE, $(CPP_FILES), $(patsubst %.cpp,%.d,$(CPP_FILE)))

CXXFLAGS = -g


all: $(DEP_FILES)
	$(MAKE) build
	@echo X: $(CPP_FILES)
	@echo X: $(OBJECT_FILES)


-include $(DEP_FILES)


build: $(EXE_NAME)


clean:
	@echo
	@echo "========= CLEANING ========="
	rm -f $(OBJECT_FILES) $(EXE_NAME)


rebuild:
	$(MAKE) clean
	$(MAKE) build


deps: $(DEP_FILES)


clean-deps:
	rm -f $(DEP_FILES)


$(EXE_NAME): $(OBJECT_FILES)
	@echo
	@echo "========= LINKING $@ ========="
	$(CXX) $(CXXFLAGS) -o $@ $^ 


.PHONY: all build clean rebuild deps clean-deps


%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MM -o $@ $<


