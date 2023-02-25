#!/bin/bash

source "../src/gsl-deploy"

_run() {
        COMMAND="$1"

        if [[ -z "$COMMAND" ]];
        then
                exit 1
        fi

        echo "$COMMAND"
}

test_process_NoGitDir_ExpectedExitStatus() {
    (process)
    assertEquals 1 "$?"
}

test_process_NoDeployDir_ExpectedExitStatus() {
    (process /var/git/my_repo.git)
    assertEquals 1 "$?"
}

test_process_NoDockerParams_ExpectedExitStatus() {
    (process /var/git/my_repo.git /var/deploy)
    assertEquals 1 "$?"
}

test_process_NoBranch_ExpectedExitStatus() {
    (process /var/git/my_repo.git /var/deploy "--build --deploy")
    assertEquals 1 "$?"
}

test_process_NoEnvFile_ReturnsExpected() {
    RESULT="$(process /var/git/my_repo.git /var/deploy "--build --deploy" main)"
    assertEquals "checkout /var/git/my_repo.git main /var/deploy/deploy_main; deploy /var/deploy/deploy_main \"--build --deploy\" " "$RESULT"
}

test_process_ValidEnvFile_ReturnsExpected() {
    RESULT="$(process /var/git/my_repo.git /var/deploy "--build --deploy" main .env.dev)"
    assertEquals "checkout /var/git/my_repo.git main /var/deploy/deploy_main; deploy /var/deploy/deploy_main \"--build --deploy\" .env.dev" "$RESULT"
}

# Load shUnit2.
. shunit2
