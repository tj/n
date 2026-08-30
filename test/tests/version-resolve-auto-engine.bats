#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


# auto
# engine is a label too! These tests mostly use auto as first available only through auto.
# Most tests using engines in package.json, devEngines support added later.

function setup_file() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/version-resolve-auto-engine"
  mkdir -p "${MY_DIR}"

  # Need a version of node and npx available for reading package.json
  export N_PREFIX="${MY_DIR}"
  export PATH="${MY_DIR}/bin:${PATH}"
  n install lts
}

function teardown_file() {
  rm -rf "${MY_DIR}"
}

function setup() {
  rm -f "${MY_DIR}/package.json"
}

function write_engines() {
  echo '{ "engines" : { "node" : "'"$1"'" } }' > package.json
}

@test "setupAll for auto-engine # (1 install)" {
  # Dummy test so setupAll displayed while running first setup
}

@test "auto engine, 8.9.0" {
  cd "${MY_DIR}"
  write_engines "8.9.0"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.9.0"
}

@test "auto engine, v8.9.1" {
  cd "${MY_DIR}"
  write_engines "v8.9.1"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.9.1"
}

@test "auto engine, =8.9.2" {
  cd "${MY_DIR}"
  write_engines "=8.9.2"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.9.2"
}

@test "auto engine, =v8.9.3" {
  cd "${MY_DIR}"
  write_engines "=v8.9.3"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.9.3"
}

@test "engine, =v8.9.4" {
  cd "${MY_DIR}"
  write_engines "=v8.9.4"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION engine)"
  assert_equal "${output}" "8.9.4"
}

@test "auto engine, >1" {
  local TARGET_VERSION="$(display_remote_version latest)"
  cd "${MY_DIR}"
  write_engines ">1"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "${TARGET_VERSION}"
}

@test "auto engine, >=2" {
  local TARGET_VERSION="$(display_remote_version latest)"
  cd "${MY_DIR}"
  write_engines ">=2"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "${TARGET_VERSION}"
}

@test "auto engine, 8" {
  cd "${MY_DIR}"
  write_engines "8"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.17.0"
}

@test "auto engine, 8.x" {
  cd "${MY_DIR}"
  write_engines "8.x"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.17.0"
}

@test "auto engine, 8.X" {
  cd "${MY_DIR}"
  write_engines "8.X"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.17.0"
}

@test "auto engine, 8.*" {
  cd "${MY_DIR}"
  write_engines "8.*"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.17.0"
}

@test "auto engine, ~8.11.0" {
  cd "${MY_DIR}"
  write_engines "~8.11.0"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.4"
}

@test "auto engine, ~8.11" {
  cd "${MY_DIR}"
  write_engines "~8.11"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.4"
}

@test "auto engine, ~8" {
  cd "${MY_DIR}"
  write_engines "~8"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.17.0"
}

@test "auto engine, ^8.11.0" {
  cd "${MY_DIR}"
  write_engines "^8.11.0"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.17.0"
}

@test "auto engine, ^8.x" {
  cd "${MY_DIR}"
  write_engines "^8.x"
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.17.0"
}

@test "auto engine, subdir" {
  cd "${MY_DIR}"
  write_engines "8.11.2"
  mkdir -p sub-engine
  cd sub-engine
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.2"
}

@test "auto engine (semver), <8.12" {
  cd "${MY_DIR}"
  write_engines "<8.12"
  # newer versions of npx not liking proxy as used in tests
  output="$(https_proxy= n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.4"
}

@test "auto engine (semver), 8.11.1 - 8.11.3" {
  cd "${MY_DIR}"
  write_engines "8.11.1 - 8.11.3"
  # newer versions of npx not liking proxy as used in tests
  output="$(https_proxy= n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.3"
}

@test "auto engine (semver), >8.1 <8.12 || >2.1 <3.4" {
  cd "${MY_DIR}"
  write_engines ">8.1 <8.12 || >2.1 <3.4"
  # newer versions of npx not liking proxy as used in tests
  output="$(https_proxy= n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.11.4"
}

@test "auto (devEngines) object, 8.9.0" {
  cd "${MY_DIR}"
  echo '{ "devEngines" : { "runtime" : { "name": "node", "version": "8.9.0" } } }' > package.json
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.9.0"
}

@test "auto (devEngines) array, 8.9.0" {
  cd "${MY_DIR}"
  echo '{ "devEngines" : { "runtime" : [{ "name": "bun", "version": "1.2.3" }, { "name": "node", "version": "8.9.0" }] } }' > package.json
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.9.0"
}

@test "engine (devEngines, semver), <8.12" {
  cd "${MY_DIR}"
  echo '{ "devEngines" : { "runtime" : { "name": "node", "version": "<8.12" } } }' > package.json
  # newer versions of npx not liking proxy as used in tests
  output="$(https_proxy= n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION engine)"
  assert_equal "${output}" "8.11.4"
}

@test "engine mismatch devEngines match engines" {
  cd "${MY_DIR}"
  write_engines "8.9.1"
  echo '{ "devEngines" : { "runtime" : { "name": "bun", "version": "1.2.3" } } }' >> package.json
  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION engine)"
  assert_equal "${output}" "8.9.1"
}
