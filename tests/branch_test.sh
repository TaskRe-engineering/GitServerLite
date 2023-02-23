#!/bin/bash

source "../src/gsl-source"

test_branch_SimpleBranchName_ReturnsExpected() {
    local RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records/main /var/myrepo/.gitserverlite/deploy_records)"
    assertEquals "main" "$RESULT"
}

test_branch_NestedFolderBranchName_ReturnsExpected() {
    local RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records/wip/mybranch /var/myrepo/.gitserverlite/deploy_records)"
    assertEquals "wip/mybranch" "$RESULT"
}

test_branch_RelativePaths_ReturnsExpected() {
    local RESULT="$(branch .gitserverlite/deploy_records/main .gitserverlite/deploy_records)"
    assertEquals "main" "$RESULT"
}

test_branch_NoBranchName_ReturnsNull() {
    local RESULT="$(branch /var/myrepo/.gitserverlite/deploy_records /var/myrepo/.gitserverlite/deploy_records)"
    assertNull "$RESULT"
}

test_branch_NoDeployDir_ReturnsFullPath() {
    local RESULT="$(branch .gitserverlite/deploy_records/wip/mybranch)"
    assertEquals ".gitserverlite/deploy_records/wip/mybranch" "$RESULT"
}

# Load shUnit2.
. shunit2
