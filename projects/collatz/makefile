FILES :=                              \
    .gitignore                        \
    .travis.yml                       \
    collatz-tests/EID-RunCollatz.in   \
    collatz-tests/EID-RunCollatz.out  \
    collatz-tests/EID-TestCollatz.c++ \
    collatz-tests/EID-TestCollatz.out \
    Collatz.c++                       \
    Collatz.h                         \
    Collatz.log                       \
    html                              \
    RunCollatz.c++                    \
    RunCollatz.in                     \
    RunCollatz.out                    \
    TestCollatz.c++                   \
    TestCollatz.out

ifeq ($(shell uname), Darwin)
    CXX      := g++
    COVFLAGS := -fprofile-arcs -ftest-coverage
    LDFLAGS  := /usr/local/lib/gtest_main.a
    GCOV     := gcov
    VALGRIND :=
else ifeq ($(CXX), clang++)
    COVFLAGS := --coverage
    LDFLAGS  := -lgtest -lgtest_main -pthread
    GCOV     := gcov-4.6
    VALGRIND := valgrind
else
    CXX      := g++-4.8
    COVFLAGS := -fprofile-arcs -ftest-coverage
    LDFLAGS  := -lgtest -lgtest_main -pthread
    GCOV     := gcov-4.8
    VALGRIND := valgrind
endif

CXXFLAGS := -pedantic -std=c++11 -Wall

all: RunCollatz TestCollatz

check:
	@for i in $(FILES);                                         \
	do                                                          \
        [ -e $$i ] && echo "$$i found" || echo "$$i NOT FOUND"; \
    done

clean:
	rm -f  *.gcda
	rm -f  *.gcno
	rm -f  *.gcov
	rm -f  Collatz.log
	rm -f  RunCollatz
	rm -f  RunCollatz.out
	rm -f  TestCollatz
	rm -f  TestCollatz.out
	rm -rf html

sync:
	make clean
	@echo `pwd`
	@rsync -r -t -u -v --delete \
    --include "*.c++"           \
    --include "*.h"             \
    --include "*.in"            \
    --include "makefile"        \
    --exclude "*"               \
    . downing@$(CS):cs/cs378/github/c++/projects/collatz/

test: RunCollatz.out TestCollatz.out

collatz-tests:
	git clone https://github.com/cs378-summer-2015/collatz-tests.git

html: Doxyfile Collatz.h Collatz.c++ RunCollatz.c++ TestCollatz.c++
	doxygen Doxyfile

Collatz.log:
	git log > Collatz.log

Doxyfile:
	doxygen -g

RunCollatz: Collatz.h Collatz.c++ RunCollatz.c++
	$(CXX) $(CXXFLAGS) Collatz.c++ RunCollatz.c++ -o RunCollatz

RunCollatz.out: RunCollatz
	./RunCollatz < RunCollatz.in > RunCollatz.out

TestCollatz: Collatz.h Collatz.c++ TestCollatz.c++
	$(CXX) $(COVFLAGS) $(CXXFLAGS) Collatz.c++ TestCollatz.c++ -o TestCollatz $(LDFLAGS)

TestCollatz.out: TestCollatz
	$(VALGRIND) ./TestCollatz  >  TestCollatz.out 2>&1
	$(GCOV) -b Collatz.c++     >> TestCollatz.out
	$(GCOV) -b TestCollatz.c++ >> TestCollatz.out
