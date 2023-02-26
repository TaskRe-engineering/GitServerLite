#!/bin/bash

source "../src/gsl-branch"

# Tests

test_validate_branch_name_SpaceInName_ExpectedExit() {
    BRANCH="main main"
    (validate_branch_name "$BRANCH")
    assertEquals 1 $?
}

test_validate_branch_name_SpecialCharacterInName_ExpectedExit() {
    BRANCH="main?main"
    (validate_branch_name "$BRANCH")
    assertEquals 1 $?
}

test_validate_branch_name_SingleWordName_ReturnsExpected() {
    BRANCH="main"
    (validate_branch_name "$BRANCH")
    assertEquals 0 $?
}

# Load shUnit2.
. shunit2
