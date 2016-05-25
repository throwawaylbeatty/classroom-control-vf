define users::managed_user ( $group = $title, ) {
  users { $title:
    ensure => present,
  }
  file { "/home/${title}" :
    ensure  => directory,
    owner   => $title,
    group   => $group,
  }
}
