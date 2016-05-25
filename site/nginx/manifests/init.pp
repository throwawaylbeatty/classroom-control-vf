class nginx {
# ensures the nginx webserver package is installed
  package { [ 'openssl', 'openssl-libs' ] :
    ensure => '1.0.1e-51.el7_2.5',
    before  => Package['nginx'],
  }

  file { 'nginx rpm' :
    ensure   => file,
    path     => '/opt/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
    source   => 'puppet:///modules/nginx/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
  }

  package { 'nginx' :
    ensure   => '1.6.2-1.el7.centos.ngx',
    source   => '/opt/nginx-1.6.2-1.el7.centos.ngx.x86_64.rpm',
    provider => rpm,
    require  => File['nginx rpm'],
  }
  
# ensures that a document root directory is present to store web pages.
  file { 'nginx dir' :
    path    => '/var/www',
    ensure  => directory,
  }
# ensures that the index.html file contains content from your module.
  file { 'nginx conf' :
    path    => '/etc/nginx/nginx.conf',
    ensure  => present,
    source  => 'puppet:///modules/nginx/nginx.conf',
  }
# configures nginx to point at the document root directory.
  file { 'nginx defconf' :
    path    => '/etc/nginx/conf.d/default.conf',
    ensure  => ensure,
    source  => 'puppet:///modules/nginx/default.conf',
  }
# ensures that the nginx service is running.
  service { 'start nginx' :
    name    => 'nginx',
    ensure  => running,
    enable  => true,
  }
}
