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

source "../src/gsl-branch"

# Mocks and Stubs

branch() {
    echo "$1"
}

# SetUp and tearDown

setUp() {
    GSL_BRANCHES=""
}

# Tests

test_match_BranchNameMatchingFirstRef_ReturnsExpected() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/main)"
    assertEquals "main" "$result"
}

test_match_BranchNameMatchingArbitraryRef_ReturnsExpected() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/prototype)"
    assertEquals "prototype" "$result"
}

test_match_NoBranchNameMatchingRef_ReturnsNull() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/mybranch)"
    assertNull "$result"
}

test_match_LastPartOfBranchNameMatchingRef_ReturnsNull() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/wip/main)"
    assertNull "$result"
}

test_match_FirstPartOfBranchNameMatchingRef_ReturnsNull() {
    GSL_BRANCHES=("main" "develop" "prototype" "test")
    local result="$(match refs/heads/main/main)"
    assertNull "$result"
}

# Load shUnit2.
. shunit2
