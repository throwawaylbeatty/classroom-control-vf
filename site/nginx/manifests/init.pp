class nginx {
  case $::osfamily {
    'redhat','debian': {
      $package = 'nginx'
      $owner   = 'root'
      $group   = 'root'
      $docroot = '/var/www'
      $confdir = '/etc/nginx'
      $logdir  = '/var/log/nginx'
    }
    'windows': {
      $package = 'nginx-service'
      $owner   = 'Administrator'
      $group   = 'Administrators'
      $docroot = 'C:/ProgramData/nginx/html'
      $confdir = 'C:/ProgramData/nginx'
      $logdir  = 'C:/ProgramData/nginx/logs'
    }
    default : {
      fail("Module ${module_name} is not intended to run on ${::osfamily}")
    }
  }

  $runas_user = $::osfamily ? {
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
  }

  File {
    owner   => $owner,
    group   => $group,
    mode    => '0664',
  }

  if $::osfamily == 'RedHat' {
    Yumrepo {
      ensure              => present,
      enabled             => '1',
      gpgcheck            => '1',
      gpgkey              => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
      priority            => '99',
      skip_if_unavailable => '1',
      before              => [ Package['nginx'], Package['openssl-libs'] ],
    }


    yumrepo { 'base':
      descr      => 'CentOS-$releasever - Base',
      mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra',
    }

    yumrepo { 'updates':
      descr      => 'CentOS-$releasever - Updates',
      mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra',
    }

    yumrepo { 'extras':
      descr      => 'CentOS-$releasever - Extras',
      mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra',
    }

    yumrepo { 'centosplus':
      descr      => 'CentOS-$releasever - Plus',
      mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra',
    }

    package { [ 'openssl', 'openssl-libs' ] :
      ensure => '1.0.1e-51.el7_2.5',
      before => Package['nginx'],
    }

    file { 'nginx rpm' :
      ensure => file,
      path   => '/opt/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
      source => "puppet:///modules/${module_name}/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm",
      before => Package['nginx'],
    }

    package { 'nginx' :
      ensure   => '1.6.2-1.el7.centos.ngx',
      source   => '/opt/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
      provider => rpm,
      require  => File['nginx rpm'],
      before   => [ File['nginx conf'], File['default conf'] ],
    }
  }

  if $::osfamily != 'RedHat' {
    package { $package :
      ensure => present,
    }
  }

  file { $docroot :
    ensure  => directory,
  }

  file { 'index.html' :
    ensure  => file,
    path    => "${docroot}/index.html",
    source  => "puppet:///modules/${module_name}/index.html",
  }

  file { 'nginx conf' :
    ensure  => file,
    path    => "${confdir}/nginx.conf",
    content => template('nginx/nginx.conf.erb'),
  }

  file { 'default conf' :
    ensure  => file,
    path    => "${confdir}/conf.d/default.conf",
    content => template('nginx/default.conf.erb'),
  }

  service { 'nginx' :
    ensure    => running,
    enable    => true,
    require   => File['index.html'], 
    subscribe => [ File['nginx conf'], File['default conf'] ],
  }

}
