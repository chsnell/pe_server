define pe_server::console::authorization (
  $certname = $name,
  $match    = $name,
  $role     = 'read-write',
) {

  $console_auth = "${certname}:\n  role: ${role}\n"

  file_line { "${certname}_console_authorization":
    ensure => 'present',
    #line  => inline_template('<%= @console_auth.to_yaml %>'),
    line   => $console_auth,
    match  => $match,
    path   => '/etc/puppetlabs/console-auth/certificate_authorization.yml',
    tag    => ['console_authorization'],
    notify => Service['pe-httpd'],
  }

}
