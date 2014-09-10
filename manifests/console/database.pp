class pe_server::console::database (
  $password,
  $database = 'console',
  $username = 'console',
  $host     = 'localhost',
  $port     = '5432',
  $adapter  = 'postgresql',
) {

  file { '/etc/puppetlabs/puppet-dashboard/database.yml':
    ensure  => file,
    content => template('pe_server/database.yml.erb'),
  }

}
