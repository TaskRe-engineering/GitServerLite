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
# Created: February 20, 2023
# 
# This script contains unit tests for the branch function.
# 

. "../src/gsl-source"

# SetUp and tearDown

setUp() {
    GSL_DEPLOY_BRANCHES_DIR=""
}

# Tests

test_branch_SimpleBranchName_ReturnsExpected() {
    GSL_DEPLOY_BRANCHES_DIR="/var/myrepo/.gitserverlite/deploy_records"
    RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records/main)"
    assertEquals "main" "$RESULT"
}

test_branch_NestedFolderBranchName_ReturnsExpected() {
    GSL_DEPLOY_BRANCHES_DIR="/var/myrepo/.gitserverlite/deploy_records"
    RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records/wip/mybranch)"
    assertEquals "wip/mybranch" "$RESULT"
}

test_branch_RelativePaths_ReturnsExpected() {
    GSL_DEPLOY_BRANCHES_DIR=".gitserverlite/deploy_records"
    RESULT="$(branch .gitserverlite/deploy_records/main)"
    assertEquals "main" "$RESULT"
}

test_branch_NoBranchName_ReturnsNull() {
    GSL_DEPLOY_BRANCHES_DIR="/var/myrepo/.gitserverlite/deploy_records"
    RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records)"
    assertNull "$RESULT"
}

test_branch_NoDeployDir_ReturnsFullPath() {
    RESULT="$(branch .gitserverlite/deploy_records/wip/mybranch)"
    assertEquals ".gitserverlite/deploy_records/wip/mybranch" "$RESULT"
}

# Load shUnit2.
. ./shunit2
