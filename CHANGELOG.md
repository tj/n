# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!-- markdownlint-disable MD024 -->

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
[#441]: https://github.com/tj/n/issues/441
[#448]: https://github.com/tj/n/issues/448
[#467]: https://github.com/tj/n/issues/467
[#516]: https://github.com/tj/n/issues/516
[#518]: https://github.com/tj/n/issues/518
[#521]: https://github.com/tj/n/issues/521
[#529]: https://github.com/tj/n/issues/529
[#531]: https://github.com/tj/n/issues/531
[#532]: https://github.com/tj/n/issues/532
[#541]: https://github.com/tj/n/issues/541
[#548]: https://github.com/tj/n/issues/548

<!-- reference links for releases -->

[3.0.0]: https://github.com/tj/n/compare/v2.1.12...3.0.0
[Unreleased]: https://github.com/tj/n/compare/master...develop
