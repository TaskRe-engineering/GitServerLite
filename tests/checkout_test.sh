#!/bin/bash

source "../src/gsl-git"

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

test_checkout_NoGitDir_ExpectedExitStatus() {
    (checkout)
    assertEquals 1 "$?"
}

test_checkout_NoBranch_ExpectedExitStatus() {
    (checkout /var/git/my_repo.git)
    assertEquals 1 "$?"
}

test_checkout_NoTarget_ExpectedExitStatus() {
    (checkout /var/git/my_repo.git "main")
    assertEquals 1 "$?"
}

test_checkout_ValidParametersSingleWorkdBranch_ReturnsExpected() {
    checkout /var/git/my_repo.git main /var/deploy/deploy_main
    assertEquals "mkdir -p /var/deploy/deploy_main; git --work-tree=/var/deploy/deploy_main --git-dir=/var/git/my_repo.git checkout -f main" "$GSL_LAST_RUN"
}

# Load shUnit2.
. shunit2
