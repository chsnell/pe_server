## Common
class pe_server (
  $is_master                     = false,
  $ca_server                     = undef,
  $filebucket_server             = $::settings::server,
  $change_filebucket             = true,
  $export_puppetdb_whitelist     = true,
  $export_console_authorization  = true,
) {

  if ($ca_server) { validate_string($ca_server) }
  validate_bool($is_master)
  validate_string($filebucket_server)
  validate_bool($change_filebucket)

  validate_bool($export_puppetdb_whitelist)
  validate_bool($export_console_authorization)

  if $ca_server {
    augeas { 'puppet.conf_ca_server':
      context => '/files/etc/puppetlabs/puppet/puppet.conf',
      changes => "set main/ca_server ${ca_server}",
    }
  }

  if $change_filebucket {
    augeas { 'puppet.conf_archive_file_server':
      context => '/files/etc/puppetlabs/puppet/puppet.conf',
      changes => "set main/archive_file_server ${filebucket_server}",
    }

    if $is_master {
      ## With 3.3's directory environments, this doesn't help much.
      ## The filebucket will need to be set in each environment's site.pp
      file_line { 'seondary_filebucket':
        ensure => present,
        line   => "  server => '${filebucket_server}',",
        match  => '^\s*server\s*=>',
        path   => '/etc/puppetlabs/puppet/manifests/site.pp',
      }
    }
  }

  if $export_puppetdb_whitelist {
    @@pe_server::puppetdb::whitelist { $::clientcert:
      tag => ['puppetdb_whitelist'],
    }
  }

  if $export_console_authorization {
    @@pe_server::console::authorization { $::clientcert:
      tag => ['puppetdb_authorization'],
    }
  }
}
