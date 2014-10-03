class pe_server::console::authorization (
  $authorizations = {
    'pe-internal-dashboard' => {
      'role'      => 'read-write'
    },
  },
) {
  file { '/etc/puppetlabs/console-auth/certificate_authorization.yml':
    ensure  => 'file',
    content => inline_template('<%= @authorizations.to_yaml %>'),
    notify  => Service['pe-httpd'],
  }
}
