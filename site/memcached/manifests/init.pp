class memcached {
  package { 'Installmemcached' :
    name    => 'memcached',
    ensure  => present,
  }
  file { 'configfile' :
    path    => '/etc/sysconfig/memcached',
    ensure  => file,
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    source  => 'puppet:///modules/memcached/memcached_config',
    require => Package['Installmemcached'],
  }
  service { 'startMemcached' :
    name    => 'memcached',
    ensure  => running,
    enable  => true,
    require => File['configfile'],
    subscribe => File['configfile'],
  }
}
