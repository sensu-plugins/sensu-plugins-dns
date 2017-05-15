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
require 'ipaddr'
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

  option :class,
         description: 'Record class to resolve (IN, CH, HS, ANY)',
         short: '-c CLASS',
         long: '--class CLASS',
         default: 'IN'

  option :server,
         description: 'Server to use for resolution',
         short: '-s SERVER',
         long: '--server SERVER'

  option :port,
         description: 'Port to use for resolution',
         short: '-p PORT',
         long: '--port PORT',
         proc: proc(&:to_i)

  option :result,
         description: 'A positive result entry',
         short: '-r RESULT',
         long: '--result RESULT'

  option :regex,
         description: 'Compare results to a regular expression',
         short: '-R REGEX',
         long: '--regex-match REGEX'

  option :warn_only,
         description: 'Warn instead of critical on failure',
         short: '-w',
         long: '--warn-only',
         boolean: true

  option :debug,
         description: 'Print debug information',
         long: '--debug',
         boolean: true

  option :validate,
         description: 'Validate dnssec responses',
         short: '-v',
         long: '--validate',
         boolean: true

  option :use_tcp,
         description: 'Use tcp for resolution',
         short: '-T',
         long: '--use-tcp',
         boolean: true

  option :request_count,
         description: 'Number of DNS requests to send',
         short: '-c COUNT',
         long: '--request_count COUNT',
         proc: proc(&:to_i),
         default: 1

  option :threshold,
         description: 'Percentage of DNS queries that must succeed',
         short: '-l PERCENT',
         long: '--threshold PERCENT',
         proc: proc(&:to_i),
         default: 100

  option :timeout,
         description: 'Set timeout for query',
         short: '-T TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         default: 5

  def resolve_domain
    dnsruby_config = {}
    dnsruby_config[:nameserver] = [config[:server]] unless config[:server].nil?
    dnsruby_config[:port] = config[:port] unless config[:port].nil?
    dnsruby_config[:use_tcp] = config[:use_tcp] unless config[:use_tcp].nil?
    resolv = Dnsruby::Resolver.new(dnsruby_config)
    resolv.do_validation = true if config[:validate]

    entries = []
    count = 0
    while count < config[:request_count]
      begin
        entry = resolv.query(config[:domain], config[:type], config[:class])
        resolv.query_timeout = config[:timeout]
      rescue => e
        entry = e
      end
      entries << entry
      puts "Entry #{count}: #{entry}" if config[:debug]
      count += 1
    end

    entries
  end

  def check_against_regex(entries, regex)
    # produce an Array of entry strings
    b = if entries.answer.count > 1
          entries.answer.rrsets(config[:type].to_s).map(&:to_s)
        else
          [entries.answer.first.to_s]
        end
    b.each do |answer|
      if answer.match(regex)
        ok "Resolved #{config[:domain]} #{config[:type]} matched #{regex}"
      end
    end # b.each()
    critical "Resolved #{config[:domain]} #{config[:type]} did not match #{regex}"
  end

  def check_results(entries)
    errors = []
    success = []

    entries.each do |entry|
      if entry.class == Dnsruby::NXDomain
        errors << "Could not resolve #{config[:domain]} #{config[:type]} record"
        next
      elsif entry.class == Dnsruby::ResolvTimeout
        errors << "Could not resolve #{config[:domain]}: Query timed out"
        next
      elsif entry.is_a?(Exception)
        errors << "Could not resolve #{config[:domain]}: #{entry}"
        next
      end

      puts entry.answer if config[:debug]
      if entry.answer.length.zero?
        success << "Could not resolve #{config[:domain]} #{config[:type]} record"
      elsif config[:result]
        # special logic for checking ipaddresses with result
        # mostly for ipv6 but decided to use the same logic for
        # consistency reasons
        if config[:type] == 'A' || config[:type] == 'AAAA'
          check_ips(entries)
        # non ip type
        else
          b = if entry.answer.count > 1
                entry.answer.rrsets(config[:type].to_s).to_s
              else
                entry.answer.first.to_s
              end
          if b.include?(config[:result])
            success << "Resolved #{entry.security_level} #{config[:domain]} #{config[:type]} included #{config[:result]}"
          else
            errors << "Resolved #{config[:domain]} #{config[:type]} did not include #{config[:result]}"
          end
        end
      elsif config[:regex]
        check_against_regex(entry, Regexp.new(config[:regex]))

      elsif config[:validate]
        if entry.security_level != 'SECURE'
          error << "Resolved  #{entry.security_level} #{config[:domain]} #{config[:type]}"
        end
        success << "Resolved #{entry.security_level} #{config[:domain]} #{config[:type]}"
      else
        success << "Resolved #{config[:domain]} #{config[:type]}"
      end
    end
    [errors, success]
  end

  def check_ips(entries)
    ips = entries.answer.rrsets(config[:type]).flat_map(&:rrs).map(&:address).map(&:to_s)
    result = IPAddr.new config[:result]
    if ips.any? { |ip| (IPAddr.new ip) == result }
      ok "Resolved #{entries.security_level} #{config[:domain]} #{config[:type]} included #{config[:result]}"
    else
      critical "Resolved #{config[:domain]} #{config[:type]} did not include #{config[:result]}"
    end
  end

  def run
    unknown 'No domain specified' if config[:domain].nil?
    unknown 'Count must be 1 or more' if config[:request_count] < 1

    entries = resolve_domain
    errors, success = check_results(entries)

    percent = success.count.to_f / config[:request_count] * 100
    if percent < config[:threshold]
      output = "#{percent.to_i}% of tests succeeded: #{errors.uniq.join(', ')}"
      config[:warn_only] ? warning(output) : critical(output)
    else
      ok(success.uniq.join(', '))
    end
  end
end
