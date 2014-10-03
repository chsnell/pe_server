require 'spec_helper'

describe 'pe_server' do

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

    it { should_not contain_augeas('puppet.conf_ca_server') }
    it { should_not contain_augeas('puppet.conf_master_server') }

    it do should contain_augeas('puppet.conf_archive_file_server').with(
      'changes' => 'set main/archive_file_server master.denver.tld',
    )
    end

  end

  context "when called with ca_server and puppet_server set" do
    let :params do
      {
        :ca_server     => 'ca.denver.tld',
        :puppet_server => 'master2.denver.tld',
      }
    end

    it do should contain_augeas('puppet.conf_ca_server').with(
      'changes' => 'set main/ca_server ca.denver.tld',
    )
    end

    it do should contain_augeas('puppet.conf_master_server').with(
      'changes' => 'set main/server master2.denver.tld',
    )
    end

    it do should contain_augeas('puppet.conf_archive_file_server').with(
      'changes' => 'set main/archive_file_server master2.denver.tld',
    )
    end
  end

  context "when a custom filebucket server is specified" do
    let :params do
      {
        :ca_server         => 'ca.denver.tld',
        :puppet_server     => 'master2.denver.tld',
        :filebucket_server => 'filebucket.denver.tld',
      }
    end

    it do should contain_augeas('puppet.conf_master_server').with(
      'changes' => 'set main/server master2.denver.tld',
    )
    end

    it do should contain_augeas('puppet.conf_archive_file_server').with(
      'changes' => 'set main/archive_file_server filebucket.denver.tld',
    )
    end
  end

end
