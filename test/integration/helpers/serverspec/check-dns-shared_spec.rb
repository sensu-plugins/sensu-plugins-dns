# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'check-dns.rb'
check = "#{gem_path}/#{check_name}"
domain = 'benabrams.it'

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe command("#{check} --domain #{domain}") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/DNS OK: Resolved benabrams.it A/) }
end

describe command("#{check} --domain sensutest-a.#{domain} --result 1.1.1.1") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/DNS OK: Resolved UNCHECKED sensutest-a.benabrams.it A included 1.1.1.1/) }
end

describe command("#{check} --domain sensutest-a.#{domain} --result 1.1.2.2") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/DNS OK: Resolved UNCHECKED sensutest-a.benabrams.it A included 1.1.2.2/) }
end

describe command("#{check} --domain sensutest-a.#{domain} --result 1.1.1.1,1.1.2.2") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/DNS OK: Resolved UNCHECKED sensutest-a.benabrams.it A included 1.1.1.1,1.1.2.2/) }
end

describe command(check.to_s) do
  its(:exit_status) { should eq 3 }
  its(:stdout) { should match(/DNS UNKNOWN: No domain specified/) }
end

describe command("#{check} --domain some.non.existent.domain.tld --timeout 1") do
  its(:exit_status) { should eq 2 }
  its(:stdout) { should match(/DNS CRITICAL: 0% of tests succeeded: Could not resolve some.non.existent.domain.tld A record/) }
end

describe command("#{check} --domain sensutest-a.#{domain} --request_count 2") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/DNS OK: Resolved sensutest-a.benabrams.it A/) }
end

describe command("#{check} --domain sensutest-a.#{domain} --request_count 5") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/DNS OK: Resolved sensutest-a.benabrams.it A/) }
end
