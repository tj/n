#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


function setup() {
  unset_n_env
  setup_tmp_prefix
}


function teardown() {
  rm -rf "${TMP_PREFIX_DIR}"
}


@test "n --if-needed with exact match" {
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  # --if-needed should skip installation when exact match
  run n --if-needed 4.9.1
  assert_success
  assert_output --partial "Current version v4.9.1 satisfies requirement 4.9.1"
}


@test "n --if-needed with major version match" {
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  run n --if-needed 4
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
}


@test "n --if-needed with different major version" {  
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  # --if-needed should NOT skip when major versions differ
  n --if-needed 6
  output="$(node --version)"
  assert_equal "${output}" "v6.17.1"
}


@test "n --if-needed with major.minor version match" {
  n 4.9.0
  output="$(node --version)"
  assert_equal "${output}" "v4.9.0"
  
  run n --if-needed 4.9
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.9.0"
}


@test "n --if-needed with major.minor version upgrade" {
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  n --if-needed 4.9
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
}


@test "n --if-needed with major.minor version downgrade" {
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  n --if-needed 4.8
  output="$(node --version)"
  assert_equal "${output}" "v4.8.7"
}


@test "n --if-needed with auto major version" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo "4" > .node-version
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --if-needed auto
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}


@test "n --if-needed with codename match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo "4" > .node-version
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --if-needed argon
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}

@test "n --if-needed with codename mismatch" {
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  n --if-needed boron
  output="$(node --version)"
  assert_equal "${output}" "v6.17.1"
}


@test "n --if-needed with auto major.minor version" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo "4.8" > .node-version
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --if-needed auto
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}


@test "n --if-needed with engine range match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": ">=4"}}' > package.json
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}


@test "n --if-needed with engine range mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": ">=8 <12"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
}


@test "n --if-needed with engine || match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "8 || 10"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
}


@test "n --if-needed with engine || mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "10 || 12"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --if-needed engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v12.22.12"
}


@test "n --if-needed with engine ~x.y.z match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~8.2.0"}}' > package.json
  
  n 8.2.1
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
}


@test "n --if-needed with engine ~x.y.z mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~8.2.1"}}' > package.json
  
  n 8.2.0
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
  
  run n --if-needed engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
}


@test "n --if-needed with engine ~x.y match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~8.2"}}' > package.json
  
  n 8.2.1
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
}


@test "n --if-needed with engine ~x.y minor mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~8.3"}}' > package.json
  
  n 8.2.1
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
  
  run n --if-needed engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v8.3.0"
}


@test "n --if-needed with engine ~x match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~8"}}' > package.json
  
  n 8.2.1
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
}


@test "n --if-needed with engine ~x major mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~10"}}' > package.json
  
  n 8.2.1
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
  
  run n --if-needed engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v10.24.1"
}


@test "n --if-needed with engine ^x.y.z match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^8.1.0"}}' > package.json
  
  n 8.2.0
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
}


@test "n --if-needed with engine ^x.y.z mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^8.3.0"}}' > package.json
  
  n 8.2.0
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
  
  run n --if-needed engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v8.17.0"
}


@test "n --if-needed with engine ^x.y match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^8.1"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
}


@test "n --if-needed with engine ^x.y major mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^10.1"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --if-needed engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v10.24.1"
}


@test "n --if-needed with engine ^x match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^8"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --if-needed engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
}


@test "n --if-needed with engine ^x major mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^10"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --if-needed engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v10.24.1"
}


@test "n --if-needed latest always update" {
  local latest="$(display_remote_version latest)"
  local preinstalled="${latest%%.*}.0.0"
  
  n "${preinstalled}"
  output="$(node --version)"
  assert_equal "${output}" "v${preinstalled}"
  
  run n --if-needed latest
  assert_success

  output="$(node --version)"
  assert_equal "${output}" "v${latest}"
}


@test "n --if-needed lts match" {
  local lts="$(get_latest_lts_lowest_version)"
  
  n "${lts}"
  output="$(node --version)"
  assert_equal "${output}" "v${lts}"

  run n --if-needed lts
  assert_success
  assert_output --partial "if-needed : ^${lts}"
  assert_output --partial "satisfies requirement"

  output="$(node --version)"
  assert_equal "${output}" "v${lts}"
}


@test "n --if-needed lts mismatch" {
  local lts="$(display_remote_version lts)"
  
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"

  run n --if-needed lts
  assert_success

  output="$(node --version)"
  assert_equal "${output}" "v${lts}"
}


@test "n --if-needed lts downgrade" {
  local lts="$(display_remote_version lts)"
  
  n 25.2.0
  output="$(node --version)"
  assert_equal "${output}" "v25.2.0"

  run n --if-needed lts
  assert_success

  output="$(node --version)"
  assert_equal "${output}" "v${lts}"
}

@test "n --if-needed without existing node" {
  n --if-needed 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
}