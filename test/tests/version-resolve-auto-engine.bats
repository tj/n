#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


# auto
# engine is a label too! These tests mostly use auto as first available only through auto.

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

function write_engine() {
  echo '{ "engines" : { "node" : "'"$1"'" } }' > package.json
}

@test "setupAll for auto-engine # (1 install)" {
  # Dummy test so setupAll displayed while running first setup
}

@test "auto engine, 104.0.1" {
  cd "${MY_DIR}"
  write_engine "103.0.1"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "103.0.1$"
}

@test "auto engine, v104.0.2" {
  cd "${MY_DIR}"
  write_engine "v104.0.2"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "104.0.2$"
}

@test "auto engine, =104.0.3" {
  cd "${MY_DIR}"
  write_engine "=103.0.3"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "103.0.3$"
}

@test "auto engine, =v104.0.4" {
  cd "${MY_DIR}"
  write_engine "=v104.0.4"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "104.0.4$"
}

@test "engine, =v104.0.5" {
  cd "${MY_DIR}"
  write_engine "=v104.0.5"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION engine
  assert_output --regexp "104.0.5$"
}

@test "auto engine, >1" {
  local TARGET_VERSION="$(display_remote_version latest)"
  cd "${MY_DIR}"
  write_engine ">1"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "${TARGET_VERSION}$"
}

@test "auto engine, >=2" {
  local TARGET_VERSION="$(display_remote_version latest)"
  cd "${MY_DIR}"
  write_engine ">=2"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "${TARGET_VERSION}$"
}

@test "auto engine, 8" {
  cd "${MY_DIR}"
  write_engine "8"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.17.0$"
}

@test "auto engine, 8.x" {
  cd "${MY_DIR}"
  write_engine "8.x"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.17.0$"
}

@test "auto engine, 8.X" {
  cd "${MY_DIR}"
  write_engine "8.X"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.17.0$"
}

@test "auto engine, 8.*" {
  cd "${MY_DIR}"
  write_engine "8.*"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.17.0$"
}

@test "auto engine, ~8.11.0" {
  cd "${MY_DIR}"
  write_engine "~8.11.0"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.11.4$"
}

@test "auto engine, ~8.11" {
  cd "${MY_DIR}"
  write_engine "~8.11"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.11.4$"
}

@test "auto engine, ~8" {
  cd "${MY_DIR}"
  write_engine "~8"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.17.0$"
}

@test "auto engine, ^8.11.0" {
  cd "${MY_DIR}"
  write_engine "^8.11.0"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.17.0$"
}

@test "auto engine, ^8.x" {
  cd "${MY_DIR}"
  write_engine "^8.x"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.17.0$"
}

@test "auto engine, subdir" {
  cd "${MY_DIR}"
  write_engine "8.11.2"
  mkdir -p sub-engine
  cd sub-engine
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.11.2$"
}

@test "auto engine (semver), <8.12" {
  cd "${MY_DIR}"
  write_engine "<8.12"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.11.4$"
}

@test "auto engine (semver), 8.11.1 - 8.11.3" {
  cd "${MY_DIR}"
  write_engine "8.11.1 - 8.11.3"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.11.3$"
}

@test "auto engine (semver), >8.1 <8.12 || >2.1 <3.4" {
  cd "${MY_DIR}"
  write_engine ">8.1 <8.12 || >2.1 <3.4"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  assert_output --regexp "8.11.4$"
}
