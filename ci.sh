#!/usr/bin/env sh
set -eu

BUILD_DIR="${BUILD_DIR:-build}"
cmake -S . -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release
cmake --build "$BUILD_DIR" --config Release
ctest --test-dir "$BUILD_DIR" --build-config Release --output-on-failure

