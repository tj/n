# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!-- markdownlint-disable MD024 -->

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
[#466]: https://github.com/tj/n/issues/466
[#467]: https://github.com/tj/n/issues/467
[#512]: https://github.com/tj/n/issues/512
[#516]: https://github.com/tj/n/issues/516
[#518]: https://github.com/tj/n/issues/518
[#521]: https://github.com/tj/n/issues/521
[#528]: https://github.com/tj/n/issues/528
[#529]: https://github.com/tj/n/issues/529
[#531]: https://github.com/tj/n/issues/531
[#532]: https://github.com/tj/n/issues/532
[#534]: https://github.com/tj/n/issues/534
[#536]: https://github.com/tj/n/issues/536
[#541]: https://github.com/tj/n/issues/541
[#548]: https://github.com/tj/n/issues/548
[#562]: https://github.com/tj/n/issues/562

<!-- reference links for releases -->

[Unreleased]: https://github.com/tj/n/compare/master...develop
[3.0.2]: https://github.com/tj/n/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/tj/n/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/tj/n/compare/v2.1.12...v3.0.0
