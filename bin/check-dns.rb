#! /usr/bin/env ruby
#
#   check-dns
#
# DESCRIPTION:
#   This plugin checks DNS resolution using dnsruby .
#   Note: if testing reverse DNS with -t PTR option,
#   results will not end with trailing '.' (dot)
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux, BSD
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: dnsruby
#
# USAGE:
#   example commands
#
# NOTES:
#   Does it behave differently on specific platforms, specific use cases, etc
#
# LICENSE:
#   Copyright 2014 Sonian, Inc. and contributors. <support@sensuapp.org>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'dnsruby'
#
# DNS
#
class DNS < Sensu::Plugin::Check::CLI
  option :domain,
         description: 'Domain to resolve (or ip if type PTR)',
         short: '-d DOMAIN',
         long: '--domain DOMAIN'

  option :type,
         description: 'Record type to resolve (A, AAAA, TXT, etc) use PTR for reverse lookup',
         short: '-t RECORD',
         long: '--type RECORD',
         default: 'A'

  option :server,
         description: 'Server to use for resolution',
         short: '-s SERVER',
         long: '--server SERVER'

  option :result,
         description: 'A positive result entry',
         short: '-r RESULT',
         long: '--result RESULT'

  option :warn_only,
         description: 'Warn instead of critical on failure',
         short: '-w',
         long: '--warn-only',
         boolean: true

  option :debug,
         description: 'Print debug information',
         long: '--debug',
         boolean: true

  def resolve_domain
    resolv = config[:server].nil? ? Dnsruby::Resolver.new : Dnsruby::Resolver.new(nameserver: [config[:server]])

    entries = resolv.query(config[:domain], config[:type])

    puts "Entries: #{entries}" if config[:debug]

    entries
  end

  def run
    unknown 'No domain specified' if config[:domain].nil?

    begin
      entries = resolve_domain
      rescue  Dnsruby::NXDomain
        output = "Could not resolve #{config[:domain]} #{config[:type]} record"
        critical(output)
        return
      rescue  => e
        output =  "Couldn not resolve  #{config[:domain]}: #{e}"
        config[:warn_only] ? warning(output) : critical(output)
        return
    end
    puts entries.answer  if config[:debug]
    if entries.answer.length.zero?
      output = "Could not resolve #{config[:domain]} #{config[:type]} record"
      config[:warn_only] ? warning(output) : critical(output)
    elsif config[:result]
      if entries.answer.count > 1
        b = entries.answer.rrsets("#{config[:type]}").to_s
      else
        b = entries.answer.first.to_s
      end
      if  b.include?(config[:result])
        ok "Resolved #{config[:domain]} #{config[:type]} included #{config[:result]}"
      else
        critical "Resolved #{config[:domain]} #{config[:type]} did not include #{config[:result]}"
      end
    else
      ok "Resolved #{config[:domain]} #{config[:type]}"
    end
  end
end
