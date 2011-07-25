import '*'

class nginx( $user = 'www-data', $conf_root = '/etc/nginx', $log_root = '/var/log/nginx', $pidfile = '/var/run/nginx.pid', $workers = 1, $connections = 1024, $keepalive = 60 ) {

  $conf_dirs = [ 
    $conf_root,
    "${conf_root}/conf.d",
    "${conf_root}/includes",
    "${conf_root}/sites-available",
    "${conf_root}/sites-enabled",
  ]
  
  $main_conf = "${conf_root}/nginx.conf"
  
  package {
    'nginx':
      ensure => present;
  }

  file {
    $conf_dirs:
      ensure  => directory,
      mode    => 0755,
      owner   => root,
      group   => root,
      require => Package['nginx'];

    $main_conf:
      ensure  => file,
      mode    => 0644,
      owner   => root,
      group   => root,
      require => File[$conf_dirs],
      content => template( 'nginx/nginx.conf' );
  }

  service {
    'nginx':
      ensure    => running,
      hasstatus => true,
      subscribe => [ File[$conf_dirs], File[$main_conf] ];
  }
}
