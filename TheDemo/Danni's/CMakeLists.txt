cmake_minimum_required(VERSION 4.0)
project(C_Project C)

set(CMAKE_C_STANDARD 11)

add_library(C_Project STATIC
        demo.c)

target_include_directories (C_Project PUBLIC ../../cc65win/include)