ifeq ($(shell uname), Darwin)
    CXX       := g++
    CXXFLAGS  := -v 2>&1 | grep version
    GTEST     := head -1 /usr/local/src/gtest-1.7.0/CHANGES
    GCOV      := gcov
    GCOVFLAGS := -version | grep version
    BOOST     := /usr/local/src/boost_1_57_0/boost
    VALGRIND  :=
else ifeq ($(CXX), clang++)
    CXXFLAGS  := -v 2>&1 | grep "gcc version"
    GTEST     := dpkg -l libgtest-dev | grep libgtest
    GCOV      := gcov-4.6
    GCOVFLAGS := -v | grep gcov
    BOOST     := /usr/include/boost
    VALGRIND  := valgrind
else
    CXX       := g++-4.8
    CXXFLAGS  := -v 2>&1 | grep "gcc version"
    GTEST     := dpkg -l libgtest-dev | grep libgtest
    GCOV      := gcov-4.8
    GCOVFLAGS := -v | grep gcov
    BOOST     := /usr/include/boost
    VALGRIND  := valgrind
endif

clean:
	cd examples; make --no-print-directory clean
	@echo
	cd exercises; make --no-print-directory clean
	@echo
	cd projects/collatz; make --no-print-directory clean
	@echo
	cd quizzes; make --no-print-directory clean

config:
	git config -l

init:
	touch README
	git init
	git add README
	git commit -m 'first commit'
	git remote add origin git@github.com:gpdowning/cs378.git
	git push -u origin master

pull:
	@rsync -r -t -u -v --delete             \
    --include "Hello.c++"                   \
    --include "Assertions.c++"              \
    --include "Collatz1.h"                  \
    --include "Collatz2.h"                  \
    --include "UnitTests1.c++"              \
    --include "UnitTests2.c++"              \
    --include "UnitTests3.c++"              \
    --include "Coverage1.c++"               \
    --include "Coverage2.c++"               \
    --include "Coverage3.c++"               \
    --exclude "*"                           \
    ../../../examples/c++/ examples
	@echo
	@rsync -r -t -u -v --delete             \
    --include "collatz/"                    \
    --include "Collatz.c++"                 \
    --include "Collatz.h"                   \
    --include "gitignore.sample"            \
    --include "makefile"                    \
    --include "makefile.sample"             \
    --include "RunCollatz.c++"              \
    --include "RunCollatz.in"               \
    --include "RunCollatz.sample.out"       \
    --include "TestCollatz.c++"             \
    --include "TestCollatz.sample.out"      \
    --include "travis.sample.yml"           \
    --exclude "*"                           \
    ../../../projects/c++/ projects

push:
	make clean
	@echo
	git add .travis.yml
	git add examples
	git add exercises
	git add makefile
	git add projects
	git add quizzes
	git commit -m "another commit"
	git push
	git status

status:
	make clean
	@echo
	git add examples
	git add exercises
	git add projects
	git add quizzes
	git branch
	git remote -v
	git status

sync:
	@echo `pwd`
	@rsync -r -t -u -v --delete \
    --include "makefile"        \
    --exclude "*"               \
    . downing@$(CS):cs/cs378/github/c++/
	@echo
	cd examples; make sync
	@echo
	cd exercises; make sync
	@echo
	cd projects/collatz; make sync
	@echo
	cd quizzes; make sync

test:
	cd examples;                                    \
        make --no-print-directory test;             \
        make --no-print-directory clean;            \
        make --no-print-directory test CXX=clang++
	@echo
	cd exercises;                                   \
        make --no-print-directory test;             \
        make --no-print-directory clean;            \
        make --no-print-directory test CXX=clang++
	@echo
	cd projects/collatz;                            \
        make --no-print-directory collatz_tests;    \
        make --no-print-directory html;             \
        make --no-print-directory test;             \
        make --no-print-directory clean;            \
        make --no-print-directory test CXX=clang++; \
        make --no-print-directory check
	@echo
	cd quizzes;                                     \
        make --no-print-directory test;             \
        make --no-print-directory clean;            \
        make --no-print-directory test CXX=clang++

versions:
	uname -a
	@echo
	printenv
	@echo
	which $(CXX)
	@echo
	$(CXX) $(CXXFLAGS)
	@echo
	$(GTEST)
	@echo
	which $(GCOV)
	@echo
	$(GCOV) $(GCOVFLAGS)
ifdef VALGRIND
	@echo
	which $(VALGRIND)
	@echo
	$(VALGRIND) --version
endif
	@echo
	grep "#define BOOST_VERSION " $(BOOST)/version.hpp
	@echo
	which doxygen
	@echo
	doxygen --version
