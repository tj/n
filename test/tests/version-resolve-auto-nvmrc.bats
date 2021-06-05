#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


# auto

function setup_file() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/version-resolve-auto-nvmrc"
  mkdir -p "${MY_DIR}"
}

function teardown_file() {
  rm -rf "${MY_DIR}"
}

function setup() {
  rm -f "${MY_DIR}/.nvmrc"
}

@test "auto .nvmrc, numeric" {
  cd "${MY_DIR}"
  printf "8.10.0\n" > .nvmrc
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.10.0"
}

@test "auto .nvmrc, numeric with leading v" {
  cd "${MY_DIR}"
  printf "v8.11.0\n" > .nvmrc
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.0"
}

@test "auto .nvmrc, node" {
  local TARGET_VERSION="$(display_remote_version latest)"
  cd "${MY_DIR}"
  printf "node\n" > .nvmrc
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "${TARGET_VERSION}"
}

@test "auto .nvmrc, lts/*" {
  local TARGET_VERSION="$(display_remote_version lts)"
  cd "${MY_DIR}"
  printf "lts/*\n" > .nvmrc
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "${TARGET_VERSION}"
}

@test "auto .nvmrc, lts/argon" {
  local TARGET_VERSION="$(display_remote_version lts)"
  cd "${MY_DIR}"
  printf "lts/argon\n" > .nvmrc
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "4.9.1"
}

@test "auto .nvmrc, sub directory" {
  cd "${MY_DIR}"
  printf "v8.11.1\n" > .nvmrc
  mkdir -p sub-npmrc
  cd sub-npmrc
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.1"
}
