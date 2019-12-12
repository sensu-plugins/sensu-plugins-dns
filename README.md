[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-dns)
[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-dns.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-dns)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-dns.svg)](http://badge.fury.io/rb/sensu-plugins-dns)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-dns.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-dns)

## Sensu Plugins DNS Plugin

- [Overview](#overview)
- [Files](#files)
- [Usage examples](#usage-examples)
- [Configuration](#configuration)
  - [Sensu Go](#sensu-go)
    - [Asset registration](#asset-registration)
    - [Asset definition](#asset-definition)
    - [Check definition](#check-definition)
  - [Sensu Core](#sensu-core)
    - [Check definition](#check-definition)
- [Installation from source](#installation-from-source)
- [Additional notes](#additional-notes)
- [Contributing](#contributing)

### Overview

This plugin provides native DNS instrumentation for monitoring, including record resolution.

### Files
 * bin/check-dns-zone.rb
 * bin/check-dns.rb
 * bin/metrics-dns.rb
 
**check-dns-zone**
Checks DNS Zone using [Dnsruby](https://github.com/alexdalitz/dnsruby) and WHOIS.

**check-dns**
Checks DNS resolution using dnsruby. If testing reverse DNS with -t PTR option, results will not end with a trailing `.` (dot).

**metrics-dns**
Gathers DNS statistics like the amount of time taken to resolve a name (response time). 

## Usage examples

### Help

**check-dns.rb**
```
Usage: check-dns.rb (options)
        --class CLASS                Record class to resolve (IN, CH, HS, ANY)
        --debug                      Print debug information
    -d, --domain DOMAIN              Domain to resolve (or ip if type PTR)
    -p, --port PORT                  Port to use for resolution
    -R, --regex-match REGEX          Compare results to a regular expression
    -c, --request_count COUNT        Number of DNS requests to send
    -r, --result RESULT              A list of positive result entries (comma separated list)
    -s, --server SERVER              A comma-separated list of servers to use for resolution
    -l, --threshold PERCENT          Percentage of DNS queries that must succeed
        --timeout TIMEOUT            Set timeout for query
    -t, --type RECORD                Record type to resolve (A, AAAA, TXT, etc) use PTR for reverse lookup
    -T, --use-tcp                    Use tcp for resolution
    -v, --validate                   Validate dnssec responses
    -w, --warn-only                  Warn instead of critical on failure
```

**metrics-dns.rb**
```
Usage: metrics-dns.rb (options)
    -c, --class CLASS                Record class to resolve (IN, CH, HS, ANY)
    -d, --domain DOMAIN              Domain to resolve (or ip if type PTR)
    -p, --port PORT                  Port to use for resolution
    -S, --scheme SCHEME              Metric naming scheme, text to prepend to metric
    -s, --server SERVER              Server to use for resolution
    -t, --type RECORD                Record type to resolve (A, AAAA, TXT, etc) use PTR for reverse lookup
```

## Configuration
### Sensu Go
#### Asset registration

Assets are the best way to make use of this plugin. If you're not using an asset, please consider doing so! If you're using sensuctl 5.13 or later, you can use the following command to add the asset: 

`sensuctl asset add sensu-plugins/sensu-plugins-dns`

If you're using an earlier version of sensuctl, you can download the asset definition from [this project's Bonsai asset index page](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-dns).

#### Asset definition

```yaml
---
type: Asset
api_version: core/v2
metadata:
  name: sensu-plugins-dns
spec:
  url: https://assets.bonsai.sensu.io/271b0506fe155eaf2e137c71f643608d4ce785d4/sensu-plugins-dns_3.0.0_centos_linux_amd64.tar.gz
  sha512: 11bdaa049146e2657d80d65d062d4a442bbfe26ac358cd670f0f8eb50d4bf7f41328f45652abcc4dda3398ef14051d33e428ee6b66587b471c7135926abd262d
```

#### Check definition

```yaml
---
type: CheckConfig
spec:
  command: "check-dns.rb"
  handlers: []
  high_flap_threshold: 0
  interval: 10
  low_flap_threshold: 0
  publish: true
  runtime_assets:
  - sensu-plugins/sensu-plugins-dns
  - sensu/sensu-ruby-runtime
  subscriptions:
  - linux
```

### Sensu Core

#### Check definition
```json
{
  "checks": {
    "check-dns": {
      "command": "check-dns.rb",
      "subscribers": ["linux"],
      "interval": 10,
      "refresh": 10,
      "handlers": ["influxdb"]
    }
  }
}
```

## Installation from source

### Sensu Go

See the instructions above for [asset registration](#asset-registration).

### Sensu Core

Install and setup plugins on [Sensu Core](https://docs.sensu.io/sensu-core/latest/installation/installing-plugins/).

## Additional notes

### Sensu Go Ruby Runtime Assets

The Sensu assets packaged from this repository are built against the Sensu Ruby runtime environment. When using these assets as part of a Sensu Go resource (check, mutator, or handler), make sure to include the corresponding [Sensu Ruby Runtime Asset](https://bonsai.sensu.io/assets/sensu/sensu-ruby-runtime) in the list of assets needed by the resource.

## Contributing

See [CONTRIBUTING.md](https://github.com/sensu-plugins/sensu-plugins-dns/blob/master/CONTRIBUTING.md) for information about contributing to this plugin.
