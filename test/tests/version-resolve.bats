#!/usr/bin/env bats

# Note: full semver is resolved without lookup, so can use arbitrary versions for testing like 999.999.999

load shared-functions


function setup() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/run-version-resolve"
  mkdir -p "${MY_DIR}"
}

@test "auto, missing file" {
  cd "${MY_DIR}"
  rm -f .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -ne 0 ]
}

@test "auto, no eol" {
  cd "${MY_DIR}"
  printf "101.0.1" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "101.0.1" ]
}

@test "auto, unix eol" {
  cd "${MY_DIR}"
  printf "101.0.2\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "101.0.2" ]
}

@test "auto, Windows eol" {
  cd "${MY_DIR}"
  printf "101.0.3\r\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "101.0.3" ]
}

@test "auto, leading v" {
  cd "${MY_DIR}"
  printf "v101.0.4\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "101.0.4" ]
}

@test "auto, first line only" {
  cd "${MY_DIR}"
  printf "101.0.5\nmore text\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "101.0.5" ]
}

@test "auto, lookup" {
  # Check normal resolving, which is allowed but not required for MVP .node-version
  cd "${MY_DIR}"
  printf "4.9\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "4.9.1" ]
}
