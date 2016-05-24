class skeleton {
  file { 'skelDir':
    ensure => directory,
    path => '/etc/skel',
  }
  file { 'skel':
    ensure  => present,
    path    => '/etc/skel/.bashrc',
    source  => puppet:///modules/skeleton/files/bashrc,
  }
}
