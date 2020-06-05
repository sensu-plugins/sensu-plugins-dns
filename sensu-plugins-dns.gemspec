lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/sensu-plugins-dns'

# pvt_key = '~/.ssh/gem-private_key.pem'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.authors                = ['Sensu Plugins and contributors']
  # s.cert_chain             = ['certs/sensu-plugins.pem']
  s.date                   = Date.today.to_s
  s.description            = 'This plugin provides native DNS instrumentation
                              for monitoring, including: record resolution'
  s.email                  = '<sensu-users@googlegroups.com>'
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md CHANGELOG.md]
  s.homepage               = 'https://github.com/sensu-plugins/sensu-plugins-dns'
  s.license                = 'MIT'
  s.metadata               = { 'maintainer'         => 'sensu-plugin',
                               'development_status' => 'active',
                               'production_status'  => 'unstable - testing recommended',
                               'release_draft'      => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu-plugins-dns'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.3.0'
  # s.signing_key            = File.expand_path(pvt_key) if $PROGRAM_NAME =~ /gem\z/
  s.summary                = 'Sensu plugins for dns'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsDNS::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '~> 4.0'

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_runtime_dependency     'dnsruby', '~> 1.59', '>= 1.59.2'
  s.add_runtime_dependency     'public_suffix',             '~> 2'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  s.add_development_dependency 'github-markup',             '~> 3.0'
  s.add_runtime_dependency     'whois',                     '~> 4.0'
  # locked to keep ruby < 2.5 support
  s.add_runtime_dependency     'whois-parser',              ['> 1.0', '< 5.0']
  # locked to keep ruby < 2.5 support, this is pulled in by whois-parser
  s.add_runtime_dependency     'activesupport',             '< 6.0'
  s.add_development_dependency 'kitchen-docker',            '~> 2.6'
  s.add_development_dependency 'kitchen-localhost',         '~> 0.3'
  # locked to keep ruby 2.1 support, this is pulled in by test-kitchen
  s.add_development_dependency 'mixlib-shellout',           '~> 2.2', '< 3.1.0'
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rake',                      '~> 12.3'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rspec',                     '~> 3.1'
  s.add_development_dependency 'rubocop',                   '~> 0.51.0'
  # intentionally locked as 1.17 requires ruby 2.3+
  s.add_development_dependency 'test-kitchen',              '~> 1.16.0'
  s.add_development_dependency 'yard',                      '~> 0.9.11'
end
