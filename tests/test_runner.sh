#!/bin/bash

tests=(*_test.sh)

for test in "${tests[@]}"
do
    echo "==========================="
    echo -e "Running tests in \"$test\"."
    echo "==========================="
    ./$test
done