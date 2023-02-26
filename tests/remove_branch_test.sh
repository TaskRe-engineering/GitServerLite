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

test_remove_branch_NoBranchName_ExpectedExitStatus() {
    (remove_branch)
    assertEquals 1 $?
}

test_remove_branch_NoDeployBranchDirectory_ExpectedExitStatus() {
    (remove_branch main)
    assertEquals 1 $?
}

test_remove_branch_ValidBranchAndName_RemovesExpectedBranch() {
    remove_branch main /var/git/my_repo.git/.gitserverlite/deploy_branches
    assertEquals "remove_branch_file /var/git/my_repo.git/.gitserverlite/deploy_branches/main" "$GSL_LAST_RUN"
}

# Load shUnit2.
. shunit2
