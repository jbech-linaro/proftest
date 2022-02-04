GTEST_PATH=$(CURDIR)/googletest
LIBGTEST=$(GTEST_PATH)/build/lib/libgtest.a


CXXFLAGS = -g -ggdb -fno-omit-frame-pointer
CPPFLAGS = -I$(GTEST_PATH)/googletest/include
LDFLAGS = -L$(GTEST_PATH)/build/lib
LDLIBS = -lgtest -lpthread 

all: app

# Only rebuild gest if libgtest.a doesn't exist
ifeq ($(strip $(LIBGTEST)),)
app:
else
app: $(LIBGTEST)
endif
	g++ -o main main.cpp $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(LDLIBS)

# git clone https://github.com/google/googletest.git
$(LIBGTEST):
	mkdir -p $(GTEST_PATH)/build
	cd $(GTEST_PATH)/build && cmake -DCMAKE_C_COMPILER='gcc' -DCMAKE_CXX_COMPILER='g++' ..
	$(MAKE) -s -C $(GTEST_PATH)/build

callgrind: app
	valgrind --tool=callgrind --callgrind-out-file=callgrind.out ./main

kcachegrind: callgrind
	kcachegrind callgrind.out

# Need a pip install
gprof2dot: callgrind
	gprof2dot -s -f callgrind callgrind.out | dot -Tsvg -o output.svg | gthumb output.svg

gprof : CXXFLAGS = -pg -g -ggdb
gprof: app
	rm -f gmon.out analysis.txt
	./main && gprof -b main gmon.out > analysis.txt
	@echo "gprof generated to analysis.txt"

clean:
	rm -f main *.out *.gprof *.swp *.svg analysis.txt perf.* callgrind.*

distclean: clean
	cd $(GTEST_PATH) && git clean -xdf
