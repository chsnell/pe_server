class pe_server::mcollective (
  $primary_node_name,
  $sync_mco_credentials = true,
) {
  $credentials      = strip(file('/etc/puppetlabs/mcollective/credentials'))
  $credentials_file = '/etc/puppetlabs/mcollective/credentials'

  # If the master we're contacting is the primary, then we want its mcollective certs
  # this allows us to bootstrap new masters off a primary
  if $::servername == $primary_node_name {

    # Certificates
    file { 'pe-internal-broker-cert':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-broker.pem',
      content => file('/etc/puppetlabs/puppet/ssl/certs/pe-internal-broker.pem'),
    }

    file { 'pe-internal-puppet-console-mcollective-client-cert':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-puppet-console-mcollective-client.pem',
      content => file('/etc/puppetlabs/puppet/ssl/certs/pe-internal-puppet-console-mcollective-client.pem'),
    }

    file { 'pe-internal-mcollective-servers-cert':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
      content => file('/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem'),
    }

    file { 'pe-internal-peadmin-mcollective-client-cert':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-peadmin-mcollective-client.pem',
      content => file('/etc/puppetlabs/puppet/ssl/certs/pe-internal-peadmin-mcollective-client.pem'),
    }

    # Private Keys
    file { 'pe_internal_broker':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-broker.pem',
      content => file('/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-broker.pem'),
    }

    file { 'pe_internal_mcollective_servers':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-mcollective-servers.pem',
      content => file('/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-mcollective-servers.pem'),
    }

    file { 'pe-internal-peadmin-mcollective-client':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
      content => file('/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem'),
    }

    file { 'pe-internal-puppet-console-mcollective-client':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-puppet-console-mcollective-client.pem',
      content => file('/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-puppet-console-mcollective-client.pem'),
    }


    # Public Keys
    file { 'pe_internal_broker-public':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-broker.pem',
      content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-broker.pem'),
    }

    file { 'pe_internal_mcollective_servers-public':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-mcollective-servers.pem',
      content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-mcollective-servers.pem'),
    }

    file { 'pe_internal_peadmin_mcollective_client-public':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
      content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem'),
    }

    file { 'pe_internal_puppet_console_mcollective_client-public':
      ensure  => file,
      path    => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-puppet-console-mcollective-client.pem',
      content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-puppet-console-mcollective-client.pem'),
    }
  }


  if $sync_mco_credentials {
    exec { 'mco-credentials':
      command   => "echo \"${credentials}\" > ${credentials_file}",
      unless    => "grep -qw \"${credentials}\" ${credentials_file}",
      path      => [ '/bin' ],
      logoutput => true,
    }
  }

}
