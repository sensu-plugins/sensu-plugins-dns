#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
### Added
- Add support for making multiple requests, with a threshold for success

## [1.1.0]
### Added
- Added option for DNS server port (@apriljo)
- Added option for use TCP instead of UDP (@liqw33d)
- Added `--class` argument to both metric and check scripts (@nickjacques)
- Added DNS lookup timeout option (@winks)
- check-dns.rb will now ignore case and expand shorthand when comparing ipv4 and pev6 records by turning them into ipaddr objects for comparison (@majormoses)

## [1.0.0] - 2016-05-11
### Added
- Added support for Regular Expression matching
- Added simple response time metric
- Added dnssec validation --validate
- Unlocked the dnsruby dependency to allow upgrades
- Support for Ruby 2.3

### Removed
- Support for Ruby 1.9.3

### Changed
- Upgrade to rubocop 0.40 and cleanup

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.1.0...HEAD
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.0.0...1/1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.6...1.0.0
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.1...0.0.2
