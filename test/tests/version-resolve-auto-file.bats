#!/usr/bin/env bats

# Not testing all the permutations on both files, as know they are currenly implemented using same code!

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


# auto

function setup_file() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/version-resolve-auto-file"
  mkdir -p "${MY_DIR}"
}

function teardown_file() {
  rm -rf "${MY_DIR}"
}

function setup() {
  rm -f "${MY_DIR}/.n-node-version"
  rm -f "${MY_DIR}/.node-version"
}

@test "auto, missing file" {
  cd "${MY_DIR}"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert [ "$status" -ne 0 ]
}

@test "auto .n-node-version, no eol" {
  cd "${MY_DIR}"
  printf "8.1.0" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.1.0"
}

@test "auto .n-node-version, unix eol" {
  cd "${MY_DIR}"
  printf "8.1.1\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.1.1"
}

@test "auto .n-node-version, Windows eol" {
  cd "${MY_DIR}"
  printf "8.1.2\r\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.1.2"
}

@test "auto .n-node-version, leading v" {
  cd "${MY_DIR}"
  printf "v8.1.3\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.1.3"
}

@test "auto .n-node-version, first line only" {
  cd "${MY_DIR}"
  printf "8.1.4\nmore text\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.1.4"
}

@test "auto .n-node-version, from sub directory" {
  cd "${MY_DIR}"
  printf "8.2.0\n" > .n-node-version
  mkdir -p sub6
  cd sub6
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.2.0"
}

@test "auto .node-version, partial version lookup" {
  # Check normal resolving
  cd "${MY_DIR}"
  printf "4.9\n" > .node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "4.9.1"
}

@test "auto .node-version, from sub directory" {
  cd "${MY_DIR}"
  printf "8.2.1\n" > .n-node-version
  mkdir -p sub7
  cd sub7
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.2.1"
}

