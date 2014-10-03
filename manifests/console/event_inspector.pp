class pe_server::console::event_inspector (
  $console_cert_name  = 'pe-internal-dashboard',
  $puppetdb_port      = '8081',
  $puppetdb_host      = $::fqdn,
) {

  if !(is_integer($puppetdb_port)) {
    fail('puppetdb_port must be an integer')
  }

  file { 'pe_event_inspector_config':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => '/opt/puppet/share/event-inspector/config/config.yml',
    content => template('pe_server/event_inspector_config.yml.erb'),
  }

}
