#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

## [1.0.0] - 2016-05-11
### Added
- Added support for Regular Expression matching
- Added simple response time metric
- Added dnssec validation --validate
- Unlocked the dnsruby dependency to allow upgrades
- Support for Ruby 2.3

### Removed
- Support for Ruby 1.9.3

## [0.0.6] - 2015-09-28
### Changed
- Migrated from ruby library resolv to dnsruby to support more dns related checks

## [0.0.5] - 2015-08-05
### Removed
- PTR lookups no longer end with a dot '.'

### Changed
- Removed need for dig and replace with ruby resolv
- general gem cleanup

## [0.0.4] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.3] - 2015-06-02
### Fixed
- added binstubs

### Changed
- removed cruft from /lib

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.0.0...HEAD
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.6...1.0.0
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.1...0.0.2
