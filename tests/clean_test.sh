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

# 
# GitServerLite - A lightweight set of scripts to set up and manage a Git repository
#                 that automatically deploys your Dockerized services for you.
#                 https://github.com/TaskRe-engineering/GitServerLite
# 
# File: branch_test.sh
# Author: Kier von Konigslow
# Created: April 30, 2023
# 
# This script contains unit tests for the clean function.
# 

. "../src/gsl-source"

# Mocks and Stubs

_run() {
    command="$1"

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

test_clean_NoTarget_ExpectedExitStatus() {
    (clean)
    assertEquals 1 "$?"
}

test_clean_TargetIsRoot_ExpectedExitStatus() {
    (clean /)
    assertEquals 1 "$?"
}

test_clean_ValidTarget_ReturnsExpected() {
    clean /var/deploy/deploy_main
    assertEquals "rm -rf /var/deploy/deploy_main" "$GSL_LAST_RUN"
}

# Load shUnit2.
. ./shunit2
