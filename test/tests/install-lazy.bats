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


@test "n --lazy with exact match" {
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  # --lazy should skip installation when exact match
  run n --lazy 4.9.1
  assert_success
  assert_output --partial "Current version v4.9.1 satisfies requirement 4.9.1"
}


@test "n --lazy with major version match" {
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  run n --lazy 4
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
}


@test "n --lazy with different major version" {  
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  # --lazy should NOT skip when major versions differ
  n --lazy 6
  output="$(node --version)"
  assert_equal "${output}" "v6.17.1"
}


@test "n --lazy with major.minor version match" {
  n 4.9.0
  output="$(node --version)"
  assert_equal "${output}" "v4.9.0"
  
  run n --lazy 4.9
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.9.0"
}


@test "n --lazy with major.minor version upgrade" {
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  n --lazy 4.9
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
}


@test "n --lazy with major.minor version downgrade" {
  n 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
  
  n --lazy 4.8
  output="$(node --version)"
  assert_equal "${output}" "v4.8.7"
}


@test "n --lazy with auto major version" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo "4" > .node-version
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --lazy auto
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}


@test "n --lazy with codename" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo "4" > .node-version
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --lazy argon
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}


@test "n --lazy with auto major.minor version" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo "4.8" > .node-version
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --lazy auto
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}


@test "n --lazy with engine range match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": ">=4"}}' > package.json
  
  n 4.8.0
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
  
  run n --lazy engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v4.8.0"
}


@test "n --lazy with engine range mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": ">=8 <12"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --lazy engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
}


@test "n --lazy with engine || match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "8 || 10"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --lazy engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
}


@test "n --lazy with engine || mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "10 || 12"}}' > package.json
  
  n 8.16.0
  output="$(node --version)"
  assert_equal "${output}" "v8.16.0"
  
  run n --lazy engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v12.22.12"
}


@test "n --lazy with engine ~ match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~8.2.0"}}' > package.json
  
  n 8.2.1
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
  
  run n --lazy engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
}


@test "n --lazy with engine ~ mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "~8.2.1"}}' > package.json
  
  n 8.2.0
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
  
  run n --lazy engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.1"
}


@test "n --lazy with engine ^ match" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^8.1.0"}}' > package.json
  
  n 8.2.0
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
  
  run n --lazy engine
  assert_success
  assert_output --partial "satisfies requirement"
  
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
}


@test "n --lazy with engine ^ mismatch" {
  mkdir -p "${TMP_PREFIX_DIR}/project"
  cd "${TMP_PREFIX_DIR}/project"
  echo '{"engines": {"node": "^8.3.0"}}' > package.json
  
  n 8.2.0
  output="$(node --version)"
  assert_equal "${output}" "v8.2.0"
  
  run n --lazy engine
  assert_success
  
  output="$(node --version)"
  assert_equal "${output}" "v8.17.0"
}


@test "n --lazy without existing node" {
  n --lazy 4.9.1
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
}