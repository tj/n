#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

function setup_file() {
  unset_n_env
  # fixed directory so can reuse the two installs
  tmpdir="${TMPDIR:-/tmp}"
  export N_PREFIX="${tmpdir}/n/test/run-which"
  # 20.20.2 is also known as iron
  n download 20.20.2
  n download lts
  # using "latest" for download tests with run and exec
}

function teardown_file() {
  rm -rf "${N_PREFIX}"
}

@test "setupAll for run/which/exec # (2 installs)" {
  # Dummy test so setupAll displayed while running first setup
  [ -d "${N_PREFIX}/n/versions/node/20.20.2" ]
}


# n which

@test "n which 20" {
  output="$(n which 20)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/20.20.2/bin/node"
}


@test "n which v20.20.2" {
  output="$(n which v20.20.2)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/20.20.2/bin/node"
}

@test "n bin v20.20.2" {
  output="$(n bin v20.20.2)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/20.20.2/bin/node"
}

@test "n which iron" {
  output="$(n which iron)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/20.20.2/bin/node"
}

@test "n which lts" {
  output="$(n which lts)"
  local LTS_VERSION
  LTS_VERSION="$(display_remote_version lts)"
  assert_equal "$output" "${N_PREFIX}/n/versions/node/${LTS_VERSION}/bin/node"
}


# n run

@test "n run 20" {
  output="$(n run 20 --version)"
  assert_equal "$output" "v20.20.2"
}

@test "n run lts" {
  output="$(n run lts --version)"
  local LTS_VERSION
  LTS_VERSION="$(display_remote_version lts)"
  assert_equal "$output" "v${LTS_VERSION}"
}

@test "n use 20" {
  output="$(n use 20 --version)"
  assert_equal "$output" "v20.20.2"
}

@test "n as 20" {
  output="$(n as 20 --version)"
  assert_equal "$output" "v20.20.2"
}

@test "n run --download latest" {
  n rm latest || true
  n run --download latest --version
  output="$(n run latest --version)"
  local LATEST_VERSION
  LATEST_VERSION="$(display_remote_version latest)"
  assert_equal "$output" "v${LATEST_VERSION}"
}


# n exec

@test "n exec v20.20.2 node" {
  output="$(n exec v20.20.2 node --version)"
  assert_equal "$output" "v20.20.2"
}

@test "n exec 20 npm" {
  output="$(n exec 20 npm --version)"
  assert_equal "$output" "10.8.2"
}

@test "n exec lts" {
  output="$(n exec lts node --version)"
  local LTS_VERSION
  LTS_VERSION="$(display_remote_version lts)"
  assert_equal "$output" "v${LTS_VERSION}"
}

@test "n exec -d latest" {
  n rm latest || true
  n exec -d latest node --version
  output="$(n exec latest node --version)"
  local LATEST_VERSION
  LATEST_VERSION="$(display_remote_version latest)"
  assert_equal "$output" "v${LATEST_VERSION}"
}
