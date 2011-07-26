import '*'

class nginx( $user = 'www-data', $conf_root = '/etc/nginx', $log_root = '/var/log/nginx', $pidfile = '/var/run/nginx.pid', $workers = 1, $connections = 1024, $keepalive = 60 ) {
  
# Derive config dirs from $conf_root and store in variables
  $conf_d          = "${conf_root}/conf.d"
  $include_dir     = "${conf_root}/includes"
  $sites_available = "${conf_root}/sites-available"
  $sites_enabled   = "${conf_root}/sites-enabled"
  $main_conf       = "${conf_root}/nginx.conf"

# Lump all config dirs into an array to compress code later
  $conf_dirs = [ 
    $conf_root,
    $conf_d,
    $include_dir,
    $sites_available,
    $sites_enabled,
  ]
  
# Install the nginx package
  package {
    'nginx':
      ensure => present;
  }

# Set up $conf_dirs and $main_conf
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

# Keep the service running, set up dependency-based refreshes
  service {
    'nginx':
      ensure    => running,
      hasstatus => true,
      subscribe => [ File[$conf_dirs], File[$main_conf] ];
  }
}
