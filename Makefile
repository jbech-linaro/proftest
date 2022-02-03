GTEST_PATH=$(CURDIR)/googletest

CXXFLAGS = -pg -g -ggdb
CPPFLAGS = -I$(GTEST_PATH)/googletest/include
LDFLAGS = -L$(GTEST_PATH)/build/lib
LDLIBS = -lgtest -lpthread 

all: $(LDFLAGS)/libgtest.a
	g++ -o main main.cpp $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(LDLIBS)

#.PHONY: $(LDFLAGS)/libgtest.a
$(LDFLAGS)/libgtest.a: gtest

gtest: $(LDFLAGS)/libgtest.a
	mkdir -p $(GTEST_PATH)/build
	cd $(GTEST_PATH)/build && cmake -DCMAKE_C_COMPILER='gcc' -DCMAKE_CXX_COMPILER='g++' ..
	make -s -C $(GTEST_PATH)/build

clean:
	cd $(GTEST_PATH) && git clean -xdf
	rm -f main *.out *.gprof *.swp *.svg
