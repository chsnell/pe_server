require 'spec_helper'

describe 'pe_server::console' do

  ## Default osfamily for the tests. Override in each context as needed.
  let :facts do
    {
      :osfamily        => 'RedHat',
      :operatingsystem => 'RedHat',
      :fqdn            => 'console.denver.tld',
      :servername      => 'master.denver.tld',
    }
  end

  context "when called with default params but specifying a ca_server" do
    let :params do
      {
        'ca_server'  => 'ca.denver.tld',
      }
    end

    it do should contain_file('/opt/puppet/share/puppet-dashboard/certs').with(
      'ensure' => 'directory',
      'purge'  => true,
    )
    end

    it do should contain_file_line('console_ca_server').with(
      'line' => "ca_server: 'ca.denver.tld'",
    )
    end

    it do should contain_file_line('console_cn_name').with(
      'line' => "cn_name: 'pe-internal-dashboard'",
    )
    end

    it do should contain_file_line('console_ca_certificate_path').with(
      'line' => "ca_certificate_path: 'certs/pe-internal-dashboard.ca_cert.pem'",
    )
    end

    it do should contain_file_line('console_vhost_ca_certificate_path').with(
      'line' => "    SSLCACertificateFile /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.ca_cert.pem",
    )
    end

    it do should contain_file_line('console_vhost_chain_certificate_path').with(
      'line' => "    SSLCertificateChainFile /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.ca_cert.pem",
    )
    end

    it do should contain_file_line('console_ca_crl_path').with(
      'line' => "ca_crl_path: 'certs/pe-internal-dashboard.ca_crl.pem'",
    )
    end

    it do should contain_file_line('console_vhost_crl_certificate_path').with(
      'line' => "    SSLCARevocationFile /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.ca_crl.pem",
    )
    end

    it do should contain_file_line('console_certificate_path').with(
      'line' => "certificate_path: 'certs/pe-internal-dashboard.cert.pem'",
    )
    end

    it do should contain_file_line('console_vhost_certificate_path').with(
      'line' => "    SSLCertificateFile /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
    )
    end

    it do should contain_file_line('console_private_key_path').with(
      'line' => "private_key_path: 'certs/pe-internal-dashboard.private_key.pem'",
    )
    end

    it do should contain_file_line('console_vhost_private_certificate_path').with(
      'line' => '    SSLCertificateKeyFile /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem',
    )
    end

    it do should contain_file_line('console_public_key_path').with(
      'line' => "public_key_path: 'certs/pe-internal-dashboard.public_key.pem'",
    )
    end

    it do should contain_file_line('inventory_server').with(
      'line' => "inventory_server: 'master.denver.tld'",
    )
    end

    it do should contain_exec('create_console_keys').with(
      'creates' => '/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.public_key.pem',
    )
    end

    it do should contain_exec('request_console_certs').with(
      'creates' => '/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.ca_cert.pem',
    )
    end

    it do should contain_exec('retrieve_console_certs').with(
      'creates' => '/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem',
    )
    end

    it do should contain_class('pe_server::console::event_inspector').with(
      'puppetdb_host'     => 'console.denver.tld',
      'puppetdb_port'     => '8081',
      'console_cert_name' => 'pe-internal-dashboard',
    )
    end

  end

  context "when called with custom parameters" do
    let :params do
      {
        'ca_server'         => 'ca.denver.tld',
        'console_cert_name' => 'console1.denver.tld',
        'inventory_server'  => 'master2.denver.tld',
        'puppetdb_host'     => 'puppetdb.denver.tld',
      }
    end

    it do should contain_file('/opt/puppet/share/puppet-dashboard/certs').with(
      'ensure' => 'directory',
      'purge'  => true,
    )
    end

    it do should contain_file_line('console_ca_server').with(
      'line' => "ca_server: 'ca.denver.tld'",
    )
    end

    it do should contain_file_line('console_cn_name').with(
      'line' => "cn_name: 'console1.denver.tld'",
    )
    end

    it do should contain_file_line('console_ca_certificate_path').with(
      'line' => "ca_certificate_path: 'certs/console1.denver.tld.ca_cert.pem'",
    )
    end

    it do should contain_file_line('console_vhost_ca_certificate_path').with(
      'line' => "    SSLCACertificateFile /opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.ca_cert.pem",
    )
    end

    it do should contain_file_line('console_vhost_chain_certificate_path').with(
      'line' => "    SSLCertificateChainFile /opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.ca_cert.pem",
    )
    end

    it do should contain_file_line('console_ca_crl_path').with(
      'line' => "ca_crl_path: 'certs/console1.denver.tld.ca_crl.pem'",
    )
    end

    it do should contain_file_line('console_vhost_crl_certificate_path').with(
      'line' => "    SSLCARevocationFile /opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.ca_crl.pem",
    )
    end

    it do should contain_file_line('console_certificate_path').with(
      'line' => "certificate_path: 'certs/console1.denver.tld.cert.pem'",
    )
    end

    it do should contain_file_line('console_vhost_certificate_path').with(
      'line' => "    SSLCertificateFile /opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.cert.pem",
    )
    end

    it do should contain_file_line('console_private_key_path').with(
      'line' => "private_key_path: 'certs/console1.denver.tld.private_key.pem'",
    )
    end

    it do should contain_file_line('console_vhost_private_certificate_path').with(
      'line' => '    SSLCertificateKeyFile /opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.private_key.pem',
    )
    end

    it do should contain_file_line('console_public_key_path').with(
      'line' => "public_key_path: 'certs/console1.denver.tld.public_key.pem'",
    )
    end

    it do should contain_file_line('inventory_server').with(
      'line' => "inventory_server: 'master2.denver.tld'",
    )
    end

    it do should contain_exec('create_console_keys').with(
      'creates' => '/opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.public_key.pem',
    )
    end

    it do should contain_exec('request_console_certs').with(
      'creates' => '/opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.ca_cert.pem',
    )
    end

    it do should contain_exec('retrieve_console_certs').with(
      'creates' => '/opt/puppet/share/puppet-dashboard/certs/console1.denver.tld.cert.pem',
    )
    end

    it do should contain_class('pe_server::console::event_inspector').with(
      'puppetdb_host'     => 'puppetdb.denver.tld',
      'puppetdb_port'     => '8081',
      'console_cert_name' => 'console1.denver.tld',
    )
    end

  end

end
