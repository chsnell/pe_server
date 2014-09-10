## Class for PuppetDB servers
## This will collect all exported resources that add to the whitelist
##
## Optionally, you can manage PostgreSQL via the PuppetDB class.
## Unfortunately, the PE PostgreSQL settings are managed by the PuppetDB class.

class pe_server::puppetdb (
  $manage_postgres            = true,
  $postgres_listen_address    = '*',
  $postgres_database_host     = $::fqdn,
  $puppetdb_ssl_setup         = true,
  $collect_exported_whitelist = true,
) {

  validate_bool($collect_exported_whitelist)
  validate_bool($manage_postgres)
  validate_string($postgres_listen_address)
  validate_string($postgres_database_host)
  validate_bool($puppetdb_ssl_setup)

  if $collect_exported_whitelist {
    Pe_secondary::Puppetdb::Whitelist <<| tag == 'puppetdb_whitelist' |>>
  }

  if $manage_postgres {
    class { 'pe_puppetdb::pe':
      postgres_listen_addresses => $postgres_listen_address,
      database_host             => $postgres_database_host,
    }
  }

  if $puppetdb_ssl_setup {
    exec { 'puppetdb_ssl_setup':
      command => '/opt/puppet/sbin/puppetdb ssl-setup -f',
      unless  => "/usr/bin/cmp /etc/puppetlabs/puppetdb/ssl/public.pem /etc/puppetlabs/puppet/ssl/certs/${::clientcert}.pem"
    }
  }

}
