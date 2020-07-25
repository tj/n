#!/usr/bin/env bats

load shared-functions


# auto

function setup() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/version-resolve-auto-engine"
  mkdir -p "${MY_DIR}"
  rm -f "${MY_DIR}/package.json"

  # Need a version of node and npx available for reading package.json
  export N_PREFIX="${MY_DIR}"
  export PATH="${MY_DIR}/bin:${PATH}"
  # beforeAll
  if [[ "${BATS_TEST_NUMBER}" -eq 1 ]] ; then
    n install lts
  fi

  # Output looks likes:
  ##        found : package.json
  ##         read : 101.0.1
  ## v101.0.1
  # so version payload is...
  PAYLOAD_SIMPLE_LINE=2

  # Output looks likes:
  ##        found : package.json
  ##       read : 4.8.2 - 4.8.4
  ##  resolving : 4.8.2 - 4.8.4
  ## v4.8.4
  # so version payload is...
  PAYLOAD_COMPLEX_LINE=3
}

function teardown() {
  # afterAll
  if [[ "${#BATS_TEST_NAMES[@]}" -eq "${BATS_TEST_NUMBER}" ]] ; then
    rm -rf "${MY_DIR}"
  fi
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
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "103.0.1" ]
}

@test "auto engine, v104.0.2" {
  cd "${MY_DIR}"
  write_engine "v104.0.2"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "104.0.2" ]
}

@test "auto engine, =104.0.3" {
  cd "${MY_DIR}"
  write_engine "=103.0.3"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "103.0.3" ]
}

@test "auto engine, =v104.0.4" {
  cd "${MY_DIR}"
  write_engine "=v104.0.4"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "104.0.4" ]
}

@test "auto engine, >1" {
  local TARGET_VERSION="$(display_remote_version latest)"
  cd "${MY_DIR}"
  write_engine ">1"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "${TARGET_VERSION}" ]
}

@test "auto engine, >=2" {
  local TARGET_VERSION="$(display_remote_version latest)"
  cd "${MY_DIR}"
  write_engine ">=2"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "${TARGET_VERSION}" ]
}

@test "auto engine, 8" {
  cd "${MY_DIR}"
  write_engine "8"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.17.0" ]
}

@test "auto engine, 8.x" {
  cd "${MY_DIR}"
  write_engine "8.x"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.17.0" ]
}

@test "auto engine, 8.X" {
  cd "${MY_DIR}"
  write_engine "8.X"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.17.0" ]
}

@test "auto engine, 8.*" {
  cd "${MY_DIR}"
  write_engine "8.*"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.17.0" ]
}

@test "auto engine, ~8.11.0" {
  cd "${MY_DIR}"
  write_engine "~8.11.0"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.11.4" ]
}

@test "auto engine, ~8.11" {
  cd "${MY_DIR}"
  write_engine "~8.11"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.11.4" ]
}

@test "auto engine, ~8" {
  cd "${MY_DIR}"
  write_engine "~8"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.17.0" ]
}

@test "auto engine, ^8.11.0" {
  cd "${MY_DIR}"
  write_engine "^8.11.0"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.17.0" ]
}

@test "auto engine, ^8.x" {
  cd "${MY_DIR}"
  write_engine "^8.x"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.17.0" ]
}

@test "auto engine, subdir" {
  cd "${MY_DIR}"
  write_engine "8.11.2"
  mkdir -p sub-engine
  cd sub-engine
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_SIMPLE_LINE}]}" = "8.11.2" ]
}

@test "auto engine (semver), <8.12" {
  cd "${MY_DIR}"
  write_engine "<8.12"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_COMPLEX_LINE}]}" = "8.11.4" ]
}

@test "auto engine (semver), 8.11.1 - 8.11.3" {
  cd "${MY_DIR}"
  write_engine "8.11.1 - 8.11.3"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_COMPLEX_LINE}]}" = "8.11.3" ]
}

@test "auto engine (semver), >8.1 <8.12 || >2.1 <3.4" {
  cd "${MY_DIR}"
  write_engine ">8.1 <8.12 || >2.1 <3.4"
  run n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "${lines[${PAYLOAD_COMPLEX_LINE}]}" = "8.11.4" ]
}
