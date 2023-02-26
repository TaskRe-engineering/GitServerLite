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
# File: validate_branch_name_test.sh
# Author: Kier von Konigslow
# Created: February 24, 2023
# 
# This script contains unit tests for the validate_branch_name function.
# 

. "../src/gsl-source"

# Tests

test_validate_branch_name_SpaceInName_ExpectedExit() {
    BRANCH="main main"
    (validate_branch_name "$BRANCH")
    assertEquals 64 $?
}

test_validate_branch_name_SpecialCharacterInName_ExpectedExit() {
    BRANCH="main?main"
    (validate_branch_name "$BRANCH")
    assertEquals 64 $?
}

test_validate_branch_name_SingleWordName_ReturnsExpected() {
    BRANCH="main"
    (validate_branch_name "$BRANCH")
    assertEquals 0 $?
}

# Load shUnit2.
. ./shunit2
