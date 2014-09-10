## Defined type to allow adding certificates to PuppetDB's whitelist
define pe_server::puppetdb::whitelist (
  $certname = $name,
  $match    = $name,
) {

  file_line { "${name}_puppetdb_whitelist":
    ensure => 'present',
    line   => $certname,
    match  => $match,
    path   => '/etc/puppetlabs/puppetdb/certificate-whitelist',
    tag    => ['puppetdb_whitelist'],
    notify => Service['pe-puppetdb'],
  }

}
