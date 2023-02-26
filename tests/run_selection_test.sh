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
# File: run_selection_test.sh
# Author: Kier von Konigslow
# Created: February 25, 2023
# 
# This script contains unit tests for the run_selection function.
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

test_run_selection_NoCommandGiven_ExpectedExitStatus() {
    (run_selection)
    assertEquals 1 $?
}

test_run_selection_UnrecognizedCommandGiven_ExpectedExitStatus() {
    (run_selection "notvalidcommand")
    assertEquals 1 $?
}

test_run_selection_HelpCommandGiven_RunsExpectedCommand() {
    run_selection "help"
    assertEquals "display_manual" "$GSL_LAST_RUN"
}

test_run_selection_AddBranchCommandGiven_RunsExpectedCommand() {
    run_selection "add-branch" "main"
    assertEquals "add_branch main" "$GSL_LAST_RUN"
}

test_run_selection_AddBranchCommandGiven_RunsExpectedCommand() {
    run_selection "remove-branch" "main"
    assertEquals "remove_branch main" "$GSL_LAST_RUN"
}

test_run_selection_ListCommandGiven_RunsExpectedCommand() {
    run_selection "list"
    assertEquals "list" "$GSL_LAST_RUN"
}

test_run_selection_ShowBranchCommandGiven_RunsExpectedCommand() {
    run_selection "show-branch" "develop"
    assertEquals "show_branch develop" "$GSL_LAST_RUN"
}

test_run_selection_ShowDeployLocationCommandGiven_RunsExpectedCommand() {
    run_selection "show-deploy-location"
    assertEquals "show_deploy_directory" "$GSL_LAST_RUN"
}

test_run_selection_ShowDeployLocationCommandGiven_RunsExpectedCommand() {
    run_selection "version"
    assertEquals "show_version" "$GSL_LAST_RUN"
}

# Load shUnit2.
. ./shunit2
