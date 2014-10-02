## Common class.  This applies to all nodes using the 'pe_server' module,
## including agents.
class pe_server (
  $ca_server                     = undef,
  $puppet_server                 = undef,
  $filebucket_server             = undef,
  $export_puppetdb_whitelist     = true,
  $export_console_authorization  = true,
) {

  if ($ca_server) { validate_string($ca_server) }
  if ($puppet_server) { validate_string($puppet_server) }
  if ($filebucket_server) { validate_string($filebucket_server) }
  validate_bool($export_puppetdb_whitelist)
  validate_bool($export_console_authorization)

  ## If a filebucket_server wasn't specified, default it to the puppet_server
  ## If puppet_server is not specified, default it to $::servername (what's
  ## compiling the catalog).  In a 'puppet apply', this is undef, and won't
  ## be managed.
  ## if puppet_server is set.  Otherwise, use what was specified.
  ## This is looks a little weird, because we're using the value from another
  ## parameter here.
  ## See https://tickets.puppetlabs.com/browse/PUP-1985
  case $filebucket_server {
    undef: {
      if $puppet_server {
        $_filebucket_server = $puppet_server
      }
      else {
        $_filebucket_server = $::servername
      }
    }
    default: {
      $_filebucket_server = $filebucket_server
    }
  }

  ## If a CA server is specified, manage it
  if $ca_server {
    augeas { 'puppet.conf_ca_server':
      context => '/files/etc/puppetlabs/puppet/puppet.conf',
      changes => "set main/ca_server ${ca_server}",
    }
  }

  ## If a Puppet master server was specified, manage it
  if $puppet_server {
    augeas { 'puppet.conf_master_server':
      context => '/files/etc/puppetlabs/puppet/puppet.conf',
      changes => "set main/server ${puppet_server}",
    }
  }

  ## If a filebucket server is specified, manage it
  if $_filebucket_server {
    augeas { 'puppet.conf_archive_file_server':
      context => '/files/etc/puppetlabs/puppet/puppet.conf',
      changes => "set main/archive_file_server ${_filebucket_server}",
    }
  }

  ## Optionally export an entry for the PuppetDB whitelist
  ## This will be collected (optionally) with the pe_server::puppetdb class.
  if $export_puppetdb_whitelist {
    @@pe_server::puppetdb::whitelist { $::clientcert:
      tag => ['puppetdb_whitelist'],
    }
  }

  ## Optionally export an entry for the console authorization.
  ## This will be collected (optionally) with the pe_server::console class.
  if $export_console_authorization {
    @@pe_server::console::authorization { $::clientcert:
      tag => ['puppetdb_authorization'],
    }
  }
}
