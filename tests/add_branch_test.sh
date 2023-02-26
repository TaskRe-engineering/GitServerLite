#!/usr/bin/env bash

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
}

# Tests

test_add_branch_NoBranchName_ExpectedExitStatus() {
    (add_branch)
    assertEquals 1 $?
}

test_add_branch_InvalidBranchName_ExpectedExitStatus() {
    (add_branch "main?main")
    assertEquals 64 $?
}

test_add_branch_ValidBranchNameNoEnvFile_ReturnsExpected() {
    read() {
        :
    }
    add_branch "main" > /dev/null
    assertEquals "create_branch_file main " "$GSL_LAST_RUN"
}

test_add_branch_ValidBranchNameWithEnvFile_ReturnsExpected() {
    read() {
        env_file=".env.dev"
    }
    add_branch "main" > /dev/null
    assertEquals "create_branch_file main .env.dev" "$GSL_LAST_RUN"
}

# Load shUnit2.
. shunit2
