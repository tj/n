# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!-- markdownlint-disable MD024 -->

## [4.1.0]

### Added

- 'n uninstall` to remove node and npm
- describe `NODE_MIRROR` in `README`

### Removed

- `PROJECT_NAME` and `PROJECT_URL` from `README`. First step to deprecating `n project`. Open an issue if you still need this!

## [4.0.0]

Only minor functional changes, but technically could break scripts relying on specific behaviour.

### Fixed

- remove trailing space from `bin` output [#456]

### Added

- development tests [#545]

### Changed

- internal: improve shell script based on ShellCheck suggestions, quoting variables use etc [#187] [#465]
- put single quote marks around parameters to clarify error messages [#485]
- update terminology to be more careful with current/latest [#522]

## [3.0.2] (2019-04-07)

### Added

- instructions to avoid need for `sudo` when installing to `/usr/local`  [#416] [#562]

### Fixed

- permission denied errors when running read-only commands without sudo [#416]

## [3.0.1] (2019-04-05)

### Added

- install instruction using Homebrew (macOS) [#534]
- Table of Contents to README [#466]

### Fixed

- lts lookup on node mirrors which don't purge old versions (e.g. taobao) [#512]
- hide cursor while selecting version from menu [#528]

### Removed

- gitter badge from README, as gitter chatroom inactive
- inactive Core Team from README
- instructions for scripted install of npm from README, which should no longer be needed and not working on Mac [#536]

## [3.0.0] (2019-03-29)

### Added

- detect arm64 architecture [#448][] [#521][]

### Changed

- allow `n rm` of active version of node [#541][] [#169][] [#327][] [#441][]
- show more version examples in README, including partial version number [#548][]
- updated description of interactive version selection [#518][]
- make (old) stable an alias for lts [#467][] [#335][]
- replace use of `which` with more standard `command -v` [#532][]

### Fixed

- error messages when selecting from version menu if active node version not listed [#541][] [#292][] [#367][] [#391][] [#400][]
- removed inappropriate `shift` from prune function [#531][] [#529][]

### Removed

- Remove old io project support [#516][] [#331][]

<!-- reference links for issues and pull requests -->

[#169]: https://github.com/tj/n/issues/169
[#187]: https://github.com/tj/n/issues/187
[#292]: https://github.com/tj/n/issues/292
[#327]: https://github.com/tj/n/issues/327
[#331]: https://github.com/tj/n/issues/331
[#335]: https://github.com/tj/n/issues/335
[#367]: https://github.com/tj/n/issues/367
[#391]: https://github.com/tj/n/issues/391
[#400]: https://github.com/tj/n/issues/400
[#416]: https://github.com/tj/n/issues/416
[#441]: https://github.com/tj/n/issues/441
[#448]: https://github.com/tj/n/issues/448
[#456]: https://github.com/tj/n/issues/456
[#465]: https://github.com/tj/n/issues/465
[#466]: https://github.com/tj/n/issues/466
[#467]: https://github.com/tj/n/issues/467
[#485]: https://github.com/tj/n/issues/485
[#512]: https://github.com/tj/n/issues/512
[#516]: https://github.com/tj/n/issues/516
[#518]: https://github.com/tj/n/issues/518
[#521]: https://github.com/tj/n/issues/521
[#522]: https://github.com/tj/n/issues/522
[#528]: https://github.com/tj/n/issues/528
[#529]: https://github.com/tj/n/issues/529
[#531]: https://github.com/tj/n/issues/531
[#532]: https://github.com/tj/n/issues/532
[#534]: https://github.com/tj/n/issues/534
[#536]: https://github.com/tj/n/issues/536
[#541]: https://github.com/tj/n/issues/541
[#545]: https://github.com/tj/n/issues/545
[#548]: https://github.com/tj/n/issues/548
[#562]: https://github.com/tj/n/issues/562

<!-- reference links for releases -->

[Unreleased]: https://github.com/tj/n/compare/master...develop
[4.1.0]: https://github.com/tj/n/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/tj/n/compare/v3.0.2...v4.0.0
[3.0.2]: https://github.com/tj/n/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/tj/n/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/tj/n/compare/v2.1.12...v3.0.0
