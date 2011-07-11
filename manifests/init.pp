import '*'

class nginx( $user = 'www-data', $conf_root = '/etc/nginx', $log_root = '/var/log/nginx', $pidfile = '/var/run/nginx.pid', $workers = 1, $connections = 1024, $keepalive = 60 ) {

  $conf_dirs = [ 
    inline_template("<%= conf_root %>"),
    inline_template("<%= conf_root %>/conf.d"),
    inline_template("<%= conf_root %>/sites-available"),
    inline_template("<%= conf_root %>/sites-enabled"),
  ]
  
  $main_conf = inline_template("<%= conf_root %>/nginx.conf")
  
  package {
    'nginx':
      ensure => present;
  }

  file {
    $conf_dirs:
      ensure  => directory,
      mode    => '755',
      owner   => root,
      group   => root,
      require => Package['nginx'];

    $main_conf:
      ensure  => file,
      mode    => '644',
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
