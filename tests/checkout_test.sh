#!/bin/bash

source "../src/gsl-git"

_run() {
        COMMAND="$1"

        if [[ -z "$COMMAND" ]];
        then
                exit 1
        fi

        echo "$COMMAND"
}

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
    RESULT="$(checkout /var/git/my_repo.git main /var/deploy/deploy_main)"
    assertEquals "mkdir -p /var/deploy/deploy_main; git --work-tree=/var/deploy/deploy_main --git-dir=/var/git/my_repo.git checkout -f main" "$RESULT"
}

# Load shUnit2.
. shunit2
