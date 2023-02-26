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

. "../src/gsl-source"

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
    GSL_DEPLOY_BRANCHES_DIR="/var/git/my_repo.git/.gitserverlite/deploy_branches"
}

# Tests

test_remove_branch_NoBranchName_ExpectedExitStatus() {
    (remove_branch)
    assertEquals 1 $?
}

test_remove_branch_ValidBranch_RemovesExpectedBranch() {
    remove_branch main
    assertEquals "remove_branch_file /var/git/my_repo.git/.gitserverlite/deploy_branches/main" "$GSL_LAST_RUN"
}

# Load shUnit2.
. ./shunit2
