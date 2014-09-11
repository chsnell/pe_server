class pe_server::console::database (
  $password,
  $console_auth_password,
  $database              = 'console',
  $username              = 'console',
  $host                  = 'localhost',
  $port                  = '5432',
  $adapter               = 'postgresql',
  $console_auth_database = 'console_auth',
  $console_auth_username = 'console_auth',
) {

  file { '/etc/puppetlabs/puppet-dashboard/database.yml':
    ensure  => file,
    content => template('pe_server/database.yml.erb'),
  }

  file { '/etc/puppetlabs/console-auth/database.yml':
    ensure  => file,
    content => template('pe_server/console_auth_database.yml.erb'),
  }

}
