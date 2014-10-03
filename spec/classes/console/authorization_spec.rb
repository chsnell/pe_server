require 'spec_helper'

describe 'pe_server::console::authorization' do

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
        'authorizations' => {
          'pe-internal-dashboard' => {
            'role'                => 'read-write'
          },
          'spear.denver.tld' => {
            'role'                => 'read-write'
          },
        }
      }
    end

    it do should contain_file('/etc/puppetlabs/console-auth/certificate_authorization.yml').with(
      'content' => "--- \n  pe-internal-dashboard: \n    role: read-write\n  spear.denver.tld: \n    role: read-write",
    )
    end

  end

end
