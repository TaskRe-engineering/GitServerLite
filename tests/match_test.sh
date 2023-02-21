#!/bin/bash

source "../src/gsl-source"

branch() {
    echo $1
}

test_Match_BranchNameMatchingRef_ReturnsExpected() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/main $BRANCHES)"
    assertEquals "main" "$RESULT"
}

test_Match_NoBranchNameMatchingRef_ReturnsNull() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/mybranch $BRANCHES)"
    assertNull "$RESULT"
}

test_Match_LastPartOfBranchNameMatchingRef_ReturnsNull() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/wip/main $BRANCHES)"
    assertNull "$RESULT"
}

test_Match_FirstPartOfBranchNameMatchingRef_ReturnsNull() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/main/main $BRANCHES)"
    assertNull "$RESULT"
}

# Load shUnit2.
. shunit2