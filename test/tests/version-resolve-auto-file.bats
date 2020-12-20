#!/usr/bin/env bats

# Note: full semver is resolved without lookup, so can use arbitrary versions for testing like 999.999.999
# Not testing all the permutations on both files, as know they are currenly implemented using same code!

load shared-functions


# auto

function setup() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/version-resolve-auto-file"
  mkdir -p "${MY_DIR}"
  rm -f "${MY_DIR}/.n-node-version"
  rm -f "${MY_DIR}/.node-version"
}

function teardown() {
  # afterAll
  if [[ "${#BATS_TEST_NAMES[@]}" -eq "${BATS_TEST_NUMBER}" ]] ; then
    rm -rf "${MY_DIR}"
  fi
}

@test "auto, missing file" {
  cd "${MY_DIR}"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -ne 0 ]
}

@test "auto .n-node-version, no eol" {
  cd "${MY_DIR}"
  printf "101.0.1" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "101.0.1" ]
}

@test "auto .n-node-version, unix eol" {
  cd "${MY_DIR}"
  printf "101.0.2\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "101.0.2" ]
}

@test "auto .n-node-version, Windows eol" {
  cd "${MY_DIR}"
  printf "101.0.3\r\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "101.0.3" ]
}

@test "auto .n-node-version, leading v" {
  cd "${MY_DIR}"
  printf "v101.0.4\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "101.0.4" ]
}

@test "auto .n-node-version, first line only" {
  cd "${MY_DIR}"
  printf "101.0.5\nmore text\n" > .n-node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "101.0.5" ]
}

@test "auto .n-node-version, from sub directory" {
  cd "${MY_DIR}"
  printf "101.0.6\nmore text\n" > .n-node-version
  mkdir -p sub6
  cd sub6
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "101.0.6" ]
}

@test "auto .node-version, partial version lookup" {
  # Check normal resolving
  cd "${MY_DIR}"
  printf "4.9\n" > .node-version
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "4.9.1" ]
}

@test "auto .node-version, from sub directory" {
  cd "${MY_DIR}"
  printf "101.0.7\nmore text\n" > .n-node-version
  mkdir -p sub7
  cd sub7
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "101.0.7" ]
}

