class memcached {
  package { 'Installmemcached':
    name    => 'memcached',
    ensure  => present,
  }
  file { 'configfile':
    path    => '/etc/sysconfig/memcached',
    ensure  => file,
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    source  => 'puppet:///modules/memcached/memcached_config',
    require => Package['Installmemcached'],
    notify  => Service['startMemcached'],
  }
  service { 'startMemcached':
    ensure  => running,
    enable  => true,
    require => File['configfile']
  }
}
