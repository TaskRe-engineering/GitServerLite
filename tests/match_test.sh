#!/bin/bash

source "../src/gsl-branch"

# Mocks and Stubs

branch() {
    echo "$1"
}

# SetUp and tearDown

setUp() {
    GSL_BRANCHES=""
}

# Tests

test_match_BranchNameMatchingFirstRef_ReturnsExpected() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/main)"
    assertEquals "main" "$result"
}

test_match_BranchNameMatchingArbitraryRef_ReturnsExpected() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/prototype)"
    assertEquals "prototype" "$result"
}

test_match_NoBranchNameMatchingRef_ReturnsNull() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/mybranch)"
    assertNull "$result"
}

test_match_LastPartOfBranchNameMatchingRef_ReturnsNull() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/wip/main)"
    assertNull "$result"
}

test_match_FirstPartOfBranchNameMatchingRef_ReturnsNull() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/main/main)"
    assertNull "$result"
}

# Load shUnit2.
. shunit2
