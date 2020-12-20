#!/usr/bin/env bats

load shared-functions

function setup() {
  unset_n_env
  # fixed directory so can reuse the two installs
  tmpdir="${TMPDIR:-/tmp}"
  export N_PREFIX="${tmpdir}/n/test/run-which"
  # beforeAll
  # See https://github.com/bats-core/bats-core/issues/39
  if [[ "${BATS_TEST_NUMBER}" -eq 1 ]] ; then
    n --download 4.9.1
    n --download lts
  fi
}

function teardown() {
  # afterAll
  if [[ "${#BATS_TEST_NAMES[@]}" -eq "${BATS_TEST_NUMBER}" ]] ; then
    rm -rf "${N_PREFIX}"
  fi
}


@test "setupAll for run/which/exec # (2 installs)" {
  # Dummy test so setupAll displayed while running first setup
  [ -d "${N_PREFIX}/n/versions/node/4.9.1" ]
}


# n which

@test "n which 4" {
  output="$(n which 4)"
  [ "$output" = "${N_PREFIX}/n/versions/node/4.9.1/bin/node" ]
}


@test "n which v4.9.1" {
  output="$(n which v4.9.1)"
  [ "$output" = "${N_PREFIX}/n/versions/node/4.9.1/bin/node" ]
}


@test "n bin v4.9.1" {
  output="$(n bin v4.9.1)"
  [ "$output" = "${N_PREFIX}/n/versions/node/4.9.1/bin/node" ]
}


@test "n which argon" {
  output="$(n which argon)"
  [ "$output" = "${N_PREFIX}/n/versions/node/4.9.1/bin/node" ]
}


@test "n which lts" {
  output="$(n which lts)"
  local LTS_VERSION="$(display_remote_version lts)"
  [ "$output" = "${N_PREFIX}/n/versions/node/${LTS_VERSION}/bin/node" ]
}


# n run

@test "n run 4" {
  output="$(n run 4 --version)"
  [ "$output" = "v4.9.1" ]
}


@test "n run lts" {
  output="$(n run lts --version)"
  local LTS_VERSION="$(display_remote_version lts)"
  [ "$output" = "v${LTS_VERSION}" ]
}


@test "n use 4" {
  output="$(n use 4 --version)"
  [ "$output" = "v4.9.1" ]
}


@test "n as 4" {
  output="$(n as 4 --version)"
  [ "$output" = "v4.9.1" ]
}




# n exec

@test "n exec v4.9.1 node" {
  output="$(n exec v4.9.1 node --version)"
  [ "$output" = "v4.9.1" ]
}


@test "n exec 4 npm" {
  output="$(n exec 4 npm --version)"
  [ "$output" = "2.15.11" ]
}


@test "n exec lts" {
  output="$(n exec lts node --version)"
  local LTS_VERSION="$(display_remote_version lts)"
  [ "$output" = "v${LTS_VERSION}" ]
}
