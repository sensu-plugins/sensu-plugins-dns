#! /usr/bin/env ruby
#
#   metrics-dns
#
# DESCRIPTION:
#   This plugin gathers some simple DNS
#   statistics, such as the amount of time taken
#   to resolve a name (response time).
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux, BSD
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: dnsruby
#
# USAGE:
#
# LICENSE:
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#
require 'sensu-plugin/metric/cli'
require 'dnsruby'
require 'benchmark'

class DNSGraphite < Sensu::Plugin::Metric::CLI::Graphite
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

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-S SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.dns"

  def run
    unknown 'No domain specified' if config[:domain].nil?

    begin
      dnsruby_config = {}
      dnsruby_config[:nameserver] = [config[:server]] unless config[:server].nil?
      dnsruby_config[:port] = config[:port] unless config[:port].nil?
      resolver = Dnsruby::Resolver.new(dnsruby_config)
      result = Benchmark.realtime { resolver.query(config[:domain], config[:type], config[:class]) }

      key_name = config[:domain].to_s.tr('.', '_')

      # Response Time stat
      output "#{config[:scheme]}.#{config[:type]}.#{key_name}.response_time", result.to_f.round(8)
    rescue Dnsruby::NXDomain
      critical "Could not resolve #{config[:domain]} #{config[:type]} record"
    rescue StandardError => e
      unknown e
    end

    # and exit 'ok'
    ok
  end
end
