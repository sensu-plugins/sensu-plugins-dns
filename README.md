## Sensu-Plugins-dns

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-dns.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-dns)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-dns.svg)](http://badge.fury.io/rb/sensu-plugins-dns)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-dns)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-dns.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-dns)

## Functionality

## Files
 * bin/check-dns

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-dns -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-dns`

#### Bundler

Add *sensu-plugins-disk-checks* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-dns' do
  options('--prerelease')
  version '0.0.1'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-dns' do
  options('--prerelease')
  version '0.0.1'
end
```

## Notes
