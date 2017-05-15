#!/usr/bin/env ruby
#
#   check-dns_spec
#
# DESCRIPTION:
#  rspec tests for check-dns
#
# OUTPUT:
#   RSpec testing output: passes and failures info
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   rspec
#
# USAGE:
#   For Rspec Testing
#
# NOTES:
#   For Rspec Testing
#
# LICENSE:
#   Copyright 2016 Sohonet Ltd <johan.vandendorpe@sohonet.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require_relative '../bin/check-dns'
require_relative './spec_helper.rb'

# rubocop:disable Style/ClassVars

class DNS
  at_exit do
    @@autorun = false
  end
end

describe DNS do
  let(:checker) { described_class.new }

  ## Simulate the system when you connect tcp
  before(:each) do
    # Default config
    checker.config[:domain] = 'google.com'
    checker.config[:timeout] = 2
    def checker.ok(*_args)
      exit 0
    end

    def checker.warning(*_args)
      exit 1
    end

    def checker.critical(*_args)
      exit 2
    end
  end

  it 'returns ok with a successful lookup' do
    begin
      success = Dnsruby::Message.decode(fixture('google_success').read)
      allow(Dnsruby::Resolver).to receive(:query).and_return(success)

      checker.run
    rescue SystemExit => e
      exit_code = e.status
    end
    expect(exit_code).to eq 0
  end

  it 'returns critical with a timeout' do
    begin
      timeout = Dnsruby::ResolvTimeout.new
      allow(checker).to receive(:resolve_domain).and_return([timeout])

      checker.run
    rescue SystemExit => e
      exit_code = e.status
    end
    expect(exit_code).to eq 2
  end

  it 'returns critical with a nxdomain' do
    begin
      timeout = Dnsruby::ResolvTimeout.new
      allow(checker).to receive(:resolve_domain).and_return([timeout])

      checker.run
    rescue SystemExit => e
      exit_code = e.status
    end
    expect(exit_code).to eq 2
  end
end
