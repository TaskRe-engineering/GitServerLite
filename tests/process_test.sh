#!/bin/bash

#
# Copyright 2023 Task Re-engineering Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

source "../src/gsl-deploy"

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
    process /var/git/my_repo.git /var/deploy "--build --deploy" main
    assertEquals "checkout /var/git/my_repo.git main /var/deploy/deploy_main; deploy /var/deploy/deploy_main \"--build --deploy\" " "$GSL_LAST_RUN"
}

test_process_ValidEnvFile_ReturnsExpected() {
    process /var/git/my_repo.git /var/deploy "--build --deploy" main .env.dev
    assertEquals "checkout /var/git/my_repo.git main /var/deploy/deploy_main; deploy /var/deploy/deploy_main \"--build --deploy\" .env.dev" "$GSL_LAST_RUN"
}

# Load shUnit2.
. shunit2