class skeleton {
  file { 'skelDir':
    ensure => directory,
    path => '/etc/skel',
  }
  file { 'skel':
    ensure  => file,
    path    => '/etc/skel/.bashrc',
    source  => puppet:///modules/skeleton/files/bashrc,
  }
}
