require 'spec_helper'

describe 'pe_server::master' do

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
    let :params do
      {
        'filebucket_server' => 'master.denver.tld',
      }
    end

    it do should contain_file_line('console.conf_certname').with(
      'line' => 'certificate_name = pe-internal-dashboard',
    )
    end

    it do should contain_file_line('sitepp_filebucket').with(
      'line' => "  server => 'master.denver.tld',",
    )
    end

  end

end
