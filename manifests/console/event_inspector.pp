class pe_server::console::event_inspector (
  $console_cert_name  = $::fqdn,
  $puppetdb_port      = '8081',
  $puppetdb_host      = $::fqdn,
) {

  file { 'pe_event_inspector_config':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => '/opt/puppet/share/event-inspector/config/config.yml',
    content => template('pe_server/event_inspector_config.yml.erb'),
  }

}
