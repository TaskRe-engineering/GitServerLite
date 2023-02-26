#!/bin/bash

source "../src/gsl-branch"

# SetUp and tearDown

setUp() {
    GSL_DEPLOY_BRANCHES_DIR=""
}

# Tests

test_branch_SimpleBranchName_ReturnsExpected() {
    GSL_DEPLOY_BRANCHES_DIR="/var/myrepo/.gitserverlite/deploy_records"
    local RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records/main)"
    assertEquals "main" "$RESULT"
}

test_branch_NestedFolderBranchName_ReturnsExpected() {
    GSL_DEPLOY_BRANCHES_DIR="/var/myrepo/.gitserverlite/deploy_records"
    local RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records/wip/mybranch)"
    assertEquals "wip/mybranch" "$RESULT"
}

test_branch_RelativePaths_ReturnsExpected() {
    GSL_DEPLOY_BRANCHES_DIR=".gitserverlite/deploy_records"
    local RESULT="$(branch .gitserverlite/deploy_records/main)"
    assertEquals "main" "$RESULT"
}

test_branch_NoBranchName_ReturnsNull() {
    GSL_DEPLOY_BRANCHES_DIR="/var/myrepo/.gitserverlite/deploy_records"
    local RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records)"
    assertNull "$RESULT"
}

test_branch_NoDeployDir_ReturnsFullPath() {
    local RESULT="$(branch .gitserverlite/deploy_records/wip/mybranch)"
    assertEquals ".gitserverlite/deploy_records/wip/mybranch" "$RESULT"
}

# Load shUnit2.
. shunit2
