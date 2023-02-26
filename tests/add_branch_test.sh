#!/bin/bash

source "../src/gsl-manage"

# Mocks and Stubs

_run() {
    local command="$1"

    if [[ -z "$command" ]];
    then
        exit 1
    fi

    GSL_LAST_RUN="$command"
}

# SetUp and tearDown

setUp() {
    GSL_LAST_RUN=""
}

# Tests

test_add_branch_NoBranchName_ExpectedExitStatus() {
    (add_branch)
    assertEquals 1 $?
}

test_add_branch_InvalidBranchName_ExpectedExitStatus() {
    (add_branch "main?main")
    assertEquals 64 $?
}

test_add_branch_ValidBranchNameNoEnvFile_ReturnsExpected() {
    read() {
        :
    }
    add_branch "main" > /dev/null
    assertEquals "create_branch_file main " "$GSL_LAST_RUN"
}

test_add_branch_ValidBranchNameWithEnvFile_ReturnsExpected() {
    read() {
        env_file=".env.dev"
    }
    add_branch "main" > /dev/null
    assertEquals "create_branch_file main .env.dev" "$GSL_LAST_RUN"
}

# Load shUnit2.
. shunit2
