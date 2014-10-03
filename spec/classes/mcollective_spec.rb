## rspec-puppet test for pe_server::mcollective
## Not anything yet - nearly every resource in this class uses the
## file() function for content with static paths for the files.
require 'spec_helper'

describe 'pe_server::mcollective' do

  ## Default osfamily for the tests. Override in each context as needed.
  let :facts do
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'RedHat',
      :fqdn            => 'spear.denver.tld',
      :clientcert      => 'spear.denver.tld',
      :servername      => 'master.denver.tld',
      :pe_version      => '3.3.2',
    }
  end

  context "when called with default params" do
  end

end
