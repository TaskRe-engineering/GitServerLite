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
    GSL_DEPLOY_BRANCHES_DIR="/var/git/my_repo.git/.gitserverlite/deploy_branches"
}

# Tests

test_remove_branch_NoBranchName_ExpectedExitStatus() {
    (remove_branch)
    assertEquals 1 $?
}

test_remove_branch_ValidBranch_RemovesExpectedBranch() {
    remove_branch main
    assertEquals "remove_branch_file /var/git/my_repo.git/.gitserverlite/deploy_branches/main" "$GSL_LAST_RUN"
}

# Load shUnit2.
. shunit2
