GTEST_PATH=$(CURDIR)/googletest
LIBGTEST=$(GTEST_PATH)/build/lib/libgtest.a

CXXFLAGS = -pg -g -ggdb
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

$(LIBGTEST):
	mkdir -p $(GTEST_PATH)/build
	cd $(GTEST_PATH)/build && cmake -DCMAKE_C_COMPILER='gcc' -DCMAKE_CXX_COMPILER='g++' ..
	make -s -C $(GTEST_PATH)/build

gprof: app
	rm -f gmon.out analysis.txt
	./main && gprof -b main gmon.out > analysis.txt
	@echo "gprof generated to analysis.txt"

clean:
	cd $(GTEST_PATH) && git clean -xdf
	rm -f main *.out *.gprof *.swp *.svg analysis.txt
