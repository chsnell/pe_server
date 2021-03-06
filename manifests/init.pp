## Common
class pe_server (
  $is_master                     = false,
  $ca_server                     = undef,
  $filebucket_server             = $::settings::server,
  $change_filebucket             = true,
  $export_puppetdb_whitelist     = true,
  $export_console_authorization  = true,
  $console_cert_name             = 'pe-internal-dashboard',
) {

  if ($ca_server) { validate_string($ca_server) }
  validate_bool($is_master)
  validate_string($filebucket_server)
  validate_bool($change_filebucket)

  validate_bool($export_puppetdb_whitelist)
  validate_bool($export_console_authorization)
  validate_string($console_cert_name)

  if $ca_server {
    augeas { 'puppet.conf_ca_server':
      context => '/files/etc/puppetlabs/puppet/puppet.conf',
      changes => "set main/ca_server ${ca_server}",
    }
  }

  if $is_master {
    ## Update the console configuration on PE 3.2 or greater
    ## This didn't exist prior to PE 3.2
    if versioncmp($::pe_version, '3.2.0') >= 0 {
      file_line { 'console.conf_certname':
        ensure => present,
        line   => "certificate_name = ${console_cert_name}",
        match  => 'certificate_name',
        path   => '/etc/puppetlabs/puppet/console.conf',
      }
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
