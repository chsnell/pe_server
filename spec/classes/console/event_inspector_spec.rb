require 'spec_helper'

describe 'pe_server::console::event_inspector' do

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
    it do should contain_file('pe_event_inspector_config').with(
      'content' => /ca_file: \S+\/certs\/pe-internal-dashboard\.ca_cert\.pem$/
    )
    end
    it do should contain_file('pe_event_inspector_config').with(
      'content' => /key: \S+\/certs\/pe-internal-dashboard\.private_key\.pem$/
    )
    end
    it do should contain_file('pe_event_inspector_config').with(
      'content' => /cert: \S+\/certs\/pe-internal-dashboard\.cert\.pem$/
    )
    end
    it do should contain_file('pe_event_inspector_config').with(
      'content' => /server: https:\/\/spear\.denver\.tld:8081$/
    )
    end
  end

  context "when called with default params" do
    let :params do
      {
        :console_cert_name => 'dashboard-spear',
        :puppetdb_port     => '720',
        :puppetdb_host     => 'puppetdb.denver.tld',
      }
    end

    it do should contain_file('pe_event_inspector_config').with(
      'content' => /ca_file: \S+\/certs\/dashboard-spear\.ca_cert\.pem$/
    )
    end
    it do should contain_file('pe_event_inspector_config').with(
      'content' => /key: \S+\/certs\/dashboard-spear\.private_key\.pem$/
    )
    end
    it do should contain_file('pe_event_inspector_config').with(
      'content' => /cert: \S+\/certs\/dashboard-spear\.cert\.pem$/
    )
    end
    it do should contain_file('pe_event_inspector_config').with(
      'content' => /server: https:\/\/puppetdb\.denver\.tld:720$/
    )
    end

  end

end
