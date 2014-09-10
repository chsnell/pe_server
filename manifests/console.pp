class pe_server::console (
  $ca_server,
  $console_cert_name              = 'pe-internal-dashboard',
  $cert_owner                     = 'puppet-dashboard',
  $cert_group                     = 'puppet-dashboard',
  $inventory_server               = $::settings::server,
  $puppetdb_host                  = $::fqdn,
  $puppetdb_port                  = '8081',
  $create_console_certs           = true,
  $console_certs_from_ca          = false,
  $collect_exported_authorization = true,
) {

  validate_string($ca_server)
  validate_string($console_cert_name)
  validate_string($cert_owner)
  validate_string($cert_group)
  validate_string($inventory_server)
  validate_string($puppetdb_host)
  validate_string($puppetdb_port)
  validate_bool($create_console_certs)
  validate_bool($console_certs_from_ca)
  validate_bool($collect_exported_authorization)

  File {
    owner => $cert_owner,
    group => $cert_group,
    mode    => '0644',
  }

  Exec {
    user    => $cert_owner,
    group   => $cert_group,
  }

  file { '/opt/puppet/share/puppet-dashboard/certs':
    ensure => directory,
    purge  => true,
  }

  file_line { 'console_ca_server':
    ensure => present,
    line   => "ca_server: '${ca_server}'",
    match  => 'ca_server:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  file_line { 'console_cn_name':
    ensure => present,
    line   => "cn_name: '${console_cert_name}'",
    match  => 'cn_name:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  file_line { 'console_ca_certificate_path':
    ensure => present,
    line   => "ca_certificate_path: 'certs/${console_cert_name}.ca_cert.pem'",
    match  => '^\s*ca_certificate_path:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  file_line { 'console_vhost_ca_certificate_path':
    ensure => present,
    line   => "    SSLCACertificateFile /opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_cert.pem",
    match  => '^\s*SSLCACertificateFile',
    path    => '/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf',
  }

  file_line { 'console_vhost_chain_certificate_path':
    ensure => present,
    line   => "    SSLCertificateChainFile /opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_cert.pem",
    match  => '^\s*SSLCertificateChainFile',
    path    => '/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf',
  }

  file_line { 'console_ca_crl_path':
    ensure => present,
    line   => "ca_crl_path: 'certs/${console_cert_name}.ca_crl.pem'",
    match  => 'ca_crl_path:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  file_line { 'console_vhost_crl_certificate_path':
    ensure => present,
    line   => "    SSLCARevocationFile /opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_crl.pem",
    match  => '^\s*SSLCARevocationFile',
    path    => '/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf',
  }

  file_line { 'console_certificate_path':
    ensure => present,
    line   => "certificate_path: 'certs/${console_cert_name}.cert.pem'",
    match  => '^\s*certificate_path:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  file_line { 'console_vhost_certificate_path':
    ensure => present,
    line   => "    SSLCertificateFile /opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.cert.pem",
    match  => '^\s*SSLCertificateFile',
    path    => '/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf',
  }

  file_line { 'console_private_key_path':
    ensure => present,
    line   => "private_key_path: 'certs/${console_cert_name}.private_key.pem'",
    match  => 'private_key_path:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  file_line { 'console_vhost_private_certificate_path':
    ensure => present,
    line   => "    SSLCertificateKeyFile /opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.private_key.pem",
    match  => '^\s*SSLCertificateKeyFile',
    path    => '/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf',
  }

  file_line { 'console_public_key_path':
    ensure => present,
    line   => "public_key_path: 'certs/${console_cert_name}.public_key.pem'",
    match  => 'public_key_path:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  file_line { 'inventory_server':
    ensure => present,
    line   => "inventory_server: '${inventory_server}'",
    match  => 'inventory_server:',
    path   => '/etc/puppetlabs/puppet-dashboard/settings.yml',
  }

  if $create_console_certs {
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.public_key.pem": }
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.cert.pem": }
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_crl.pem": }
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_cert.pem": }
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.private_key.pem":
      mode => '0600',
    }
    ## Without the (&& exit 0), we end up with race conditions
    exec { 'create_console_keys':
      command => '/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production cert:create_key_pair && exit 0',
      cwd     => '/opt/puppet/share/puppet-dashboard',
      creates => "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.public_key.pem",
      require => [ File_line['console_private_key_path', 'console_public_key_path', 'console_ca_server' ]],
    }

    exec { 'request_console_certs':
      command => '/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production cert:request && exit 0',
      cwd     => '/opt/puppet/share/puppet-dashboard',
      creates => "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_cert.pem",
      require => Exec['create_console_keys'],
    }

    exec { 'retrieve_console_certs':
      command => '/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production cert:retrieve && exit 0',
      cwd     => '/opt/puppet/share/puppet-dashboard',
      creates => "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.cert.pem",
      require => Exec['request_console_certs'],
    }
  }
  elsif $console_certs_from_ca {
    ## Retrieve the public key from the CA
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.public_key.pem":
      ensure  => 'file',
      content => file('/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-dashboard.pem'),
    }

    ## Retrieve the private key from the CA
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.private_key.pem":
      ensure  => 'file',
      content => file('/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem'),
      mode    => '0600',
    }

    ## Retreive the signed certificate from the CA
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.cert.pem":
      ensure  => 'file',
      content => file('/etc/puppetlabs/puppet/ssl/ca/signed/pe-internal-dashboard.pem'),
    }

    ## Retrieve the CA's CRL
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_crl.pem":
      ensure  => 'file',
      content => file('/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem'),
    }

    ## Retrieve the CA's certificate
    file { "/opt/puppet/share/puppet-dashboard/certs/${console_cert_name}.ca_cert.pem":
      ensure  => 'file',
      content => file('/etc/puppetlabs/puppet/ssl/ca/ca_cert.pem'),
    }
  }

  class { 'pe_server::console::event_inspector':
    puppetdb_host     => $puppetdb_host,
    puppetdb_port     => $puppetdb_port,
    console_cert_name => $console_cert_name,
  }

  if versioncmp($::pe_version, '3.2.0') >= 0 {
    file_line { 'console.conf_certname':
      ensure => present,
      line   => "certificate_name = ${console_cert_name}",
      match  => 'certificate_name',
      path   => '/etc/puppetlabs/puppet/console.conf',
    }
  }


  if defined('request_manager') {
    Class['pe_server::console'] ~> Service['pe-httpd']
  }

  if $collect_exported_authorization {
    Pe_server::Puppetdb::Authorization <<| tag == 'console_authorization' |>>
  }

}

