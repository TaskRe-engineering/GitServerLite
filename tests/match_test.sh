#!/bin/bash

source "../src/gsl-deployment-import"

branch() {
    echo $1
}

test_match_BranchNameMatchingRef_ReturnsExpected() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/main $BRANCHES)"
    assertEquals "main" "$RESULT"
}

test_match_NoBranchNameMatchingRef_ReturnsNull() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/mybranch $BRANCHES)"
    assertNull "$RESULT"
}

test_match_LastPartOfBranchNameMatchingRef_ReturnsNull() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/wip/main $BRANCHES)"
    assertNull "$RESULT"
}

test_match_FirstPartOfBranchNameMatchingRef_ReturnsNull() {
    local BRANCHES=("main" "develop" "prototype" "test")
    local RESULT="$(match refs/heads/main/main $BRANCHES)"
    assertNull "$RESULT"
}

# Load shUnit2.
. shunit2
