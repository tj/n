#!/usr/bin/env bats

# Note: full semver is resolved without lookup, so can use arbitrary versions for testing like 999.999.999

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


function setup() {
  unset_n_env
}


# node support aliases

@test "display_latest_resolved_version active" {
  local TARGET_VERSION="$(display_remote_version latest)"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION active)"
  assert_equal "$output" "${TARGET_VERSION}"
}

@test "display_latest_resolved_version lts_active" {
  local TARGET_VERSION="$(display_remote_version lts)"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION lts_active)"
  assert_equal "$output" "${TARGET_VERSION}"
}

@test "display_latest_resolved_version lts_latest" {
  local TARGET_VERSION="$(display_remote_version lts)"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION lts_latest)"
  assert_equal "$output" "${TARGET_VERSION}"
}

@test "display_latest_resolved_version lts" {
  local TARGET_VERSION="$(display_remote_version lts)"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION lts)"
  assert_equal "$output" "${TARGET_VERSION}"
}

@test "display_latest_resolved_version current" {
  local TARGET_VERSION="$(display_remote_version latest)"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION current)"
  assert_equal "$output" "${TARGET_VERSION}"
}

@test "display_latest_resolved_version supported" {
  local TARGET_VERSION="$(display_remote_version latest)"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION supported)"
  assert_equal "$output" "${TARGET_VERSION}"
}
