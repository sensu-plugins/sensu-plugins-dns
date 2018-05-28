#! /usr/bin/env ruby
#
#   check-dns
#
# DESCRIPTION:
#   This plugin checks DNS Zone using dnsruby and whois.
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
#   gem: whois
#
# USAGE:
#   example commands
#
# NOTES:
#   Does it behave differently on specific platforms, specific use cases, etc
#
# LICENSE:
#   Zubov Yuri <yury.zubau@gmail.com> sponsored by Actility, https://www.actility.com
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'dnsruby'
require 'whois'
require 'whois/parser'
require 'ipaddr'
require 'resolv'

#
# DNS
#
class DNSZone < Sensu::Plugin::Check::CLI
  option :domain,
         description: 'Domain to resolve (or ip if type PTR)',
         short: '-d DOMAIN',
         long: '--domain DOMAIN'

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

  option :warn_only,
         description: 'Warn instead of critical on failure',
         short: '-w',
         long: '--warn-only',
         boolean: true

  def resolve_ns
    Resolv::DNS.new.getresources(config[:domain], Resolv::DNS::Resource::IN::NS).map { |e| e.name.to_s }
  end

  def check_whois(entries)
    errors = []
    success = []
    client = Whois::Client.new(timeout: config[:timeout])
    record = client.lookup(config[:domain])
    parser = record.parser
    additional_text = "(whois #{parser.nameservers.map(&:name)}) (dig #{entries})"
    if Set.new(parser.nameservers.map(&:name)) == Set.new(entries)
      success << "Resolved #{config[:domain]} #{config[:type]} equal with whois #{additional_text}"
    else
      errors << "Resolved #{config[:domain]} #{config[:type]} did not include #{config[:result]} #{additional_text}"
    end
    [errors, success]
  end

  def check_results(entries)
    errors = []
    success = []

    %w[check_whois check_axfr soa_query].each do |check|
      result = send(check, entries)
      errors.push(*result[0])
      success.push(*result[1])
    end

    result = check_dns_connection(entries, true)
    errors.push(*result[0])
    success.push(*result[1])

    result = check_dns_connection(entries, false)
    errors.push(*result[0])
    success.push(*result[1])

    [errors, success]
  end

  def check_dns_connection(entries, use_tcp = false)
    errors = []
    success = []

    entries.each do |ns|
      Dnsruby::Resolv.getaddresses(ns).each do |ip|
        begin
          resolv = Dnsruby::Resolver.new(nameserver: ip.to_s, do_caching: false, use_tcp: use_tcp)
          resolv.query_timeout = config[:timeout]
          resolv.query(config[:domain], Dnsruby::Types.ANY)
          type_of_connection = use_tcp ? 'tcp' : 'udp'
          success << "Resolved DNS #{ns}(#{ip}) uses #{type_of_connection}"
        rescue StandardError
          errors << "Resolved DNS #{ns}(#{ip}) doesn't use #{type_of_connection}"
        end
      end
    end
    [errors, success]
  end

  def check_axfr(entries)
    errors = []
    success = []

    entries.each do |ns|
      Dnsruby::Resolv.new.getaddresses(ns).each do |ip|
        begin
          resolv = Dnsruby::Resolver.new(nameserver: ip.to_s, do_caching: false)
          resolv.query_timeout = config[:timeout]
          resolv.query(config[:domain], 'AXFR', 'IN')

          errors <<  "Resolved DNS #{ns}(#{ip}) has AXFR"
        rescue StandardError
          success << "Resolved DNS #{ns}(#{ip}) doesn't have AXFR"
        end
      end
    end
    [errors, success]
  end

  def soa_query(entries)
    errors = []
    success = []
    resp = ::Resolv::DNS.new.getresources(config[:domain], Resolv::DNS::Resource::IN::SOA)
    primary_serial_number = resp.map(&:serial).first
    primary_server = resp.map { |r| r.mname.to_s }
    primary_server_name = resp.map { |r| r.rname.to_s }

    entries.each_with_index do |ns, _index|
      ::Resolv::DNS.new.getaddresses(ns).each do |ip|
        serial_number = nil
        server_name = nil
        server = nil

        ::Resolv::DNS.open nameserver: ip.to_s, ndots: 1 do |dns|
          resp = dns.getresources(config[:domain], Resolv::DNS::Resource::IN::SOA)
          serial_number = resp.map(&:serial).first
          server_name = resp.map { |r| r.rname.to_s }
          server = resp.map { |r| r.mname.to_s }
        end

        if serial_number == primary_serial_number
          success << "SOA Query correct for server #{ns}(#{ip})} SOA #{server_name} (#{serial_number}) #{server} - \
SOA primary server #{primary_server_name} (#{primary_serial_number}) #{primary_server}"
        else
          errors << "SOA Query wrong for server #{ns}(#{ip})} SOA #{server_name} (#{serial_number}) #{server} - \
SOA primary server #{primary_server_name} (#{primary_serial_number}) #{primary_server}"
        end
      end
    end

    [errors, success]
  end

  def run
    unknown 'No domain specified' if config[:domain].nil?

    entries = resolve_ns
    errors, success = check_results(entries)
    percent = success.count.to_f / (success.count.to_f + errors.count.to_f) * 100
    if percent < config[:threshold]
      output = "#{percent.to_i}% of tests succeeded: #{errors.uniq.join(", \n")}"
      config[:warn_only] ? warning(output) : critical(output)
    else
      ok(success.uniq.join(", \n"))
    end
  end
end
