require 'spec_helper'

describe 'pe_server::console::database' do

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
        :password              => 'hunter2',
        :console_auth_password => 'hunter3',
      }
    end

    ## Tests for the console database
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /database: console/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /username: console/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /password: 'hunter2'/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /host: localhost/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /port: 5432/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /adapter: postgresql/
    )
    end

    ## Tests for the console_auth database
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /adapter: postgresql/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /database: console_auth/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /username: console_auth/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /password: 'hunter3'/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /host: localhost/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /port: 5432/
    )
    end
  end

  context "when called with custom params" do
    let :params do
      {
        :password              => 'hunter2',
        :console_auth_password => 'hunter3',
        :username              => 'bowie',
        :host                  => 'postgres.denver.tld',
        :port                  => '303',
        :adapter               => 'hsqldb',
        :database              => 'myconsole',
        :console_auth_database => 'myauthdb',
        :console_auth_username => 'magic',
      }
    end

    ## Tests for the console database
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /database: myconsole/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /username: bowie/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /password: 'hunter2'/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /host: postgres\.denver\.tld/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /port: 303/
    )
    end
    it do should contain_file('/etc/puppetlabs/puppet-dashboard/database.yml').with(
      'content' => /adapter: hsqldb/
    )
    end

    ## Tests for the console_auth database
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /adapter: hsqldb/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /database: myauthdb/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /username: magic/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /password: 'hunter3'/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /host: postgres\.denver\.tld/
    )
    end
    it do should contain_file('/etc/puppetlabs/console-auth/database.yml').with(
      'content' => /port: 303/
    )
    end
  end

end
