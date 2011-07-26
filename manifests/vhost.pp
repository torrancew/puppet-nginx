define nginx::vhost( $enabled = true, $docroot = '/var/www', $conf_root = '/etc/nginx', $log_root = '/var/log/nginx', $bind_addr = '127.0.0.1', $bind_port = '80'  ) {
  
  include nginx

  $vhost_root = "${conf_root}/sites-available"
  $vhost_conf = "${vhost_root}/${name}"
  $vhost_enabled = "${conf_root}/sites-enabled/${name}"

  file {
    $vhost_conf:
      ensure  => present,
      mode    => 0644,
      owner   => root,
      group   => root,
      require => File[$vhost_root],
      content => template('nginx/vhost.conf');
  }

  if $enabled == true {
    file {
      $vhost_enabled:
        ensure  => link,
        mode    => 0644,
        owner   => root,
        group   => root,
        require => File[$vhost_conf],
        notify  => Service['nginx'],
        target  => $vhost_conf;
    }
  }
}
