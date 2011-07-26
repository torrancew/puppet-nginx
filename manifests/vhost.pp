define nginx::vhost( $enabled = true, $docroot = '/var/www', $bind_addr = '127.0.0.1', $bind_port = '80'  ) {
  
# Include the nginx module (required for scope lookups)
  include nginx

# Define the vhost configs as variables
  $vhost_conf    = "${nginx::sites_available}/${name}"
  $vhost_enabled = "${nginx::sites_enabled}/${name}"

# Handle the vhost config files
  file {
    $vhost_conf:
      ensure  => present,
      mode    => 0644,
      owner   => root,
      group   => root,
      require => File[$nginx::sites_available],
      content => template('nginx/vhost.conf');

    $vhost_enabled:
      ensure  => $enabled ? {
        false   => absent,
        default => link,
      },
      mode    => 0644,
      owner   => root,
      group   => root,
      require => File[$vhost_conf],
      notify  => Service['nginx'],
      target  => $vhost_conf;
  }
}
