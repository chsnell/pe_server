require 'spec_helper'

describe 'pe_server::ca' do

  ## Default osfamily for the tests. Override in each context as needed.
  let :facts do
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'RedHat',
      :fqdn            => 'spear.denver.tld',
      :clientcert      => 'spear.denver.tld',
      :servername      => 'master.denver.tld',
    }
  end

  context "when called with default params" do
    it { should_not contain_augeas('puppet.conf_ca') }
    it { should_not contain_file_line('pe-httpd_revocation') }
    it { should_not contain_file('/etc/puppetlabs/puppet/autosign.conf') }
  end

  context "when not an active ca" do
    let :params do
      {
        :active_ca => false,
      }
    end

    it do should contain_augeas('puppet.conf_ca').with(
      'changes' => 'set master/ca false',
    )
    end

    it do should contain_file_line('pe-httpd_revocation').with(
      'line' => /\s+SSLCARevocationFile.*ssl\/crl\.pem$/
    )
    end
  end

  context "when not an autosign list is passed" do
    let :params do
      {
        :autosign  => [ 'wynkoop', 'larimer' ],
      }
    end

    it { should_not contain_file_line('pe-httpd_revocation') }

    it do should contain_file('/etc/puppetlabs/puppet/autosign.conf').with(
      'content' => /^wynkoop$\n^larimer$/
    )
    end
  end

  context "when asked to generate certificates" do
    let :params do
      {
        :generate_certs => {
          'lefthand.denver.tld' => {
            'dns_alt_names' => [
              'lefthand',
              'longmont.colorado.tld',
            ],
          },
        }
      }
    end

    it do should contain_puppet_certificate('lefthand.denver.tld').with(
      'dns_alt_names' => ['lefthand','longmont.colorado.tld'],
    )
    end
  end
end
