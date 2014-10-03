require 'spec_helper'

describe 'pe_server::puppetdb' do

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
    it do should contain_class('pe_puppetdb::pe').with(
      'postgres_listen_addresses' => '*',
      'database_host'             => 'spear.denver.tld',
    )
    end

    it do should contain_exec('puppetdb_ssl_setup').with(
      'unless' => /\/certs\/spear\.denver\.tld\.pem$/,
    )
    end
  end

  context "don't manage postgres" do
    let :params do
      { :manage_postgres => false }
    end
    it { should_not contain_class('pe_puppetdb::pe') }
  end

  context "don't do puppetdb ssl setup" do
    let :params do
      { :puppetdb_ssl_setup => false }
    end
    it { should_not contain_exec('puppetdb_ssl_setup') }
  end

  context "custom postgres database host and listen address" do
    let :params do
      {
        :postgres_database_host  => 'db.denver.tld',
        :postgres_listen_address => '127.0.0.1',
      }
    end

    it do should contain_class('pe_puppetdb::pe').with(
      'postgres_listen_addresses' => '127.0.0.1',
      'database_host'             => 'db.denver.tld',
    )
    end
  end
end
