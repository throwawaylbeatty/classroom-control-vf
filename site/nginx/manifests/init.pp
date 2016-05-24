class nginx {
# ensures the nginx webserver package is installed
  package { 'install nginx' :
    name    => 'nginx',
    ensure  => present,
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
