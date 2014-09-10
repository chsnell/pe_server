class pe_server::ca (
  $active_ca               = true,
  $autosign                = undef,
  $generate_certs          = undef,
) {
  validate_bool($active_ca)
  if $autosign { validate_array($autosign) }
  if $generate_certs { validate_hash($generate_certs) }

  ## If this is not an active CA, we need to ensure we're not acting as one and
  ## using the correct CRL for the httpd service
  if false == $active_ca {
    ## Disable the CA on this host and set the ca_server to the primary_ca
    augeas { 'puppet.conf_ca':
      context => '/files/etc/puppetlabs/puppet/puppet.conf',
      changes => 'set master/ca false',
    }

    ## Change the PE httpd revocation
    file_line { 'pe-httpd_revocation':
      ensure => present,
      match  => 'SSLCARevocationFile',
      line   => '    SSLCARevocationFile     /etc/puppetlabs/puppet/ssl/crl.pem',
      path   => '/etc/puppetlabs/httpd/conf.d/puppetmaster.conf',
    }
  }

  ## Add any certs to the CA's autosign list.  This is useful for split
  ## installs or non-standard PE certnames for various components
  if $autosign {
    file { '/etc/puppetlabs/puppet/autosign.conf':
      ensure  => 'file',
      content => join($autosign, "\n"),
    }
  }

  ## Generate certificates for any additional CA.
  ## This is intended for the primary CA to create the needed certificates
  if $generate_certs {
    $generate_certs_defaults = {
      ensure      => 'present',
      ca_location => 'local',
    }
    create_resources('puppet_certificate', $generate_certs, $generate_certs_defaults)
  }

}
