# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed [here](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md)

## [Unreleased]

## [2.0.0] - 03-29-2018
### Breaking Changes
- Dropping ruby `< 2.2` support (@yuri-zubov)

### Security
- updated yard dependency to `~> 0.9.11` per: https://nvd.nist.gov/vuln/detail/CVE-2017-17042 (@yuri-zubov sponsored by Actility, https://www.actility.com)
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@yuri-zubov sponsored by Actility, https://www.actility.com)

### Added
- Added many checks for DNS zone (@yuri-zubov sponsored by Actility, https://www.actility.com)

## [1.4.0] - 2018-03-21
### Added
- check-dns.rb: Added ability to use many name servers (@yuri-zubov)

## [1.3.0] - 2017-11-04
### Added
- Support for multiple resolvable ips (comma separated). (@adamdecaf)
- integration testing with `test-kitchen`, `kitchen-docker`, etc (@majormoses)

### Changed
- update changelog guidelines location (@majormoses)

### Removed
- removed ruby 2.0 testing (@majormoses)

## [1.2.2] - 2017-07-15
### Fixed
- check-dns.rb: fixed a bug reported in #23 regarding an undefined variable only triggered when using the `--validate` flag. (@majormoses)

### Added
- Testing for Ruby 2.4.1
- Remove redundant testing code

## [1.2.1] - 2017-05-16
### Fixed
- check-dns.rb: fixed a bug introduced in #15 as the input to check_ips changed. This bug only manifested itself when using the `-r || --result` options (@majormoses)
## [1.2.0] - 2017-05-16
### Added
- Add support for making multiple requests, with a threshold for success (@johanek)

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/2.0.0...HEAD
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.4.0...2.0.0
[1.4.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.2.1...1.3.0
[1.2.1]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.2.0...1/1.2.1
[1.2.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.1.0...1/1.2
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/1.0.0...1/1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.6...1.0.0
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-dns/compare/0.0.1...0.0.2
