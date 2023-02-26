#!/bin/bash

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
. shunit2
