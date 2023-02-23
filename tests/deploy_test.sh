#!/bin/bash

source "../src/gsl-source"

_run() {
        COMMAND="$1"

        if [[ -z "$COMMAND" ]];
        then
                exit 1
        fi

        echo "$COMMAND"
}

test_deploy_NoTarget_ExpectedExitStatus() {
    (deploy)
    assertEquals 1 "$?"
}

test_deploy_NoParameters_ExpectedExitStatus() {
    (deploy /var/deploy)
    assertEquals 1 "$?"
}

test_deploy_NoEnvFile_ReturnExpected() {
    RESULT="$(deploy /var/deploy "--build --detach")"
    assertEquals "cd /var/deploy; docker compose up --build --detach" "$RESULT"
}

test_deploy_ValidEnvFile_ReturnExpected() {
    RESULT="$(deploy /var/deploy "--build --detach" .env.dev)"
    assertEquals "cd /var/deploy; docker compose --env-file .env.dev up --build --detach" "$RESULT"
}

# Load shUnit2.
. shunit2
