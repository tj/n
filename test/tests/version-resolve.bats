#!/usr/bin/env bats

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
  printf "4.9.1" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "4.9.1" ]
}

@test "auto, unix eol" {
  cd "${MY_DIR}"
  printf "4.9.1\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "4.9.1" ]
}

@test "auto, Windows eol" {
  cd "${MY_DIR}"
  printf "4.9.1\r\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "4.9.1" ]
}

@test "auto, leading v" {
  cd "${MY_DIR}"
  printf "v4.9.1\n" > .node-version
  run n N_MOCK_DISPLAY_LATEST_RESOLVED_VERSION auto
  [ "$status" -eq 0 ]
  [ "$output" = "4.9.1" ]
}
