class memcached {
  package { 'Installmemcached':
    name    => 'memcached',
    ensure  => present,
  }
  
  file { 'configfile':
    path    => '/etc/sysconfig/memcached',
    ensure  => present,
    source  => 'puppet:///modules/memcached/memcached_config',
  }
  
  service { 'startMemcached':
    ensure  => running,
    enable  => true,
  }
  

}
