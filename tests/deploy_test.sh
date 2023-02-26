#!/bin/bash

source "../src/gsl-deploy"

# Mocks

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

test_deploy_NoTarget_ExpectedExitStatus() {
    (deploy)
    assertEquals 1 "$?"
}

test_deploy_NoParameters_ExpectedExitStatus() {
    (deploy /var/deploy)
    assertEquals 1 "$?"
}

test_deploy_NoEnvFile_ReturnExpected() {
    deploy /var/deploy "--build --detach"
    assertEquals "cd /var/deploy; docker compose up --build --detach" "$GSL_LAST_RUN"
}

test_deploy_ValidEnvFile_ReturnExpected() {
    deploy /var/deploy "--build --detach" .env.dev
    assertEquals "cd /var/deploy; docker compose --env-file .env.dev up --build --detach" "$GSL_LAST_RUN"
}

# Load shUnit2.
. shunit2
