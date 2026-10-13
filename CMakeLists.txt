cmake_minimum_required(VERSION 3.20)
project(hello_agent LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

add_library(hello_lib src/hello.cpp)
target_include_directories(hello_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

add_executable(hello src/main.cpp)
target_link_libraries(hello PRIVATE hello_lib)

enable_testing()
add_executable(hello_tests tests/hello_test.cpp)
target_link_libraries(hello_tests PRIVATE hello_lib GTest::gtest_main)
include(GoogleTest)
gtest_discover_tests(hello_tests)

