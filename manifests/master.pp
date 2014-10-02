## Configures Puppet Enterprise Masters
class pe_server::master (
  $filebucket_server             = $::settings::server,
  $change_filebucket             = true,
  $console_cert_name             = 'pe-internal-dashboard',
) {

  validate_string($filebucket_server)
  validate_bool($change_filebucket)
  validate_string($console_cert_name)

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

  if $manage_filebucket {
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
