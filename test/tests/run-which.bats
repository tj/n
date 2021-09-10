#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

function setup_file() {
  unset_n_env
  # fixed directory so can reuse the two installs
  tmpdir="${TMPDIR:-/tmp}"
  export N_PREFIX="${tmpdir}/n/test/run-which"
  n --download 4.9.1
  n --download lts
  # using "latest" for download tests with run and exec
}

function teardown_file() {
  rm -rf "${N_PREFIX}"
}

@test "setupAll for run/which/exec # (2 installs)" {
  # Dummy test so setupAll displayed while running first setup
  [ -d "${N_PREFIX}/n/versions/node/4.9.1" ]
}


# n which

@test "n which 4" {
  output="$(n which 4)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/4.9.1/bin/node"
}


@test "n which v4.9.1" {
  output="$(n which v4.9.1)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/4.9.1/bin/node"
}

@test "n bin v4.9.1" {
  output="$(n bin v4.9.1)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/4.9.1/bin/node"
}

@test "n which argon" {
  output="$(n which argon)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/4.9.1/bin/node"
}

@test "n which lts" {
  output="$(n which lts)"
  local LTS_VERSION="$(display_remote_version lts)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/${LTS_VERSION}/bin/node"
}


# n run

@test "n run 4" {
  output="$(n run 4 --version)"
  assert_equal "$output" "v4.9.1"
}

@test "n run lts" {
  output="$(n run lts --version)"
  local LTS_VERSION="$(display_remote_version lts)"
  assert_equal "$output" "v${LTS_VERSION}"
}

@test "n use 4" {
  output="$(n use 4 --version)"
  assert_equal "$output" "v4.9.1"
}

@test "n as 4" {
  output="$(n as 4 --version)"
  assert_equal "$output" "v4.9.1"
}

@test "n run --download latest" {
  n rm latest || true
  n run --download latest --version
  output="$(n run latest --version)"
  local LATEST_VERSION="$(display_remote_version latest)"
  assert_equal "$output" "v${LATEST_VERSION}"
}


# n exec

@test "n exec v4.9.1 node" {
  output="$(n exec v4.9.1 node --version)"
  assert_equal "$output" "v4.9.1"
}

@test "n exec 4 npm" {
  output="$(n exec 4 npm --version)"
  assert_equal "$output" "2.15.11"
}

@test "n exec lts" {
  output="$(n exec lts node --version)"
  local LTS_VERSION="$(display_remote_version lts)"
  assert_equal "$output" "v${LTS_VERSION}"
}

@test "n exec -d latest" {
  n rm latest || true
  n exec -d latest node --version
  output="$(n exec latest node --version)"
  local LATEST_VERSION="$(display_remote_version latest)"
  assert_equal "$output" "v${LATEST_VERSION}"
}
