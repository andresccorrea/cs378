// -------------
// Coverage1.c++
// -------------

// http://gcc.gnu.org/onlinedocs/gcc/Gcov.html

#include <cassert>  // assert
#include <iostream> // cout, endl

#include "gtest/gtest.h"

#include "Collatz2.h"

TEST(CoverageFixture, test_1) {
    ASSERT_EQ(cycle_length(1), 1);}

/*
% g++ -fprofile-arcs -ftest-coverage -pedantic -std=c++11 -Wall Coverage1.c++ -o Coverage1 /usr/local/lib/gtest_main.a



% Coverage1
Running main() from gtest_main.cc
[==========] Running 1 test from 1 test case.
[----------] Global test environment set-up.
[----------] 1 test from CoverageFixture
[ RUN      ] CoverageFixture.test_1
[       OK ] CoverageFixture.test_1 (0 ms)
[----------] 1 test from CoverageFixture (0 ms total)

[----------] Global test environment tear-down
[==========] 1 test from 1 test case ran. (0 ms total)
[  PASSED  ] 1 test.



% gcov -version
gcov (Ubuntu 4.8.2-19ubuntu1) 4.8.2
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.



% gcov -b Coverage1.c++ | grep -A 5 "File 'Coverage1.c++'"
File 'Coverage1.c++'
Lines executed:63.64% of 11
Branches executed:60.00% of 25
Taken at least once:28.00% of 25
No calls
Coverage1.c++:creating 'Coverage1.c++.gcov'
*/
