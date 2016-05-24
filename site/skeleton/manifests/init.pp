class skeleton {
  file { 'skelDir':
    ensure => directory,
    path => '/etc/skel',
  }
  file { 'skel':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => '/etc/skel/.bashrc',
    source  => 'puppet:///modules/skeleton/bashrc',
  }
}
