#
define network::nm::config(
  Enum['present', 'absent'] $ensure = 'present',
  String $config_file_name = $name,
  String $nm_service_name = $network::nm::setup::nm_service_name,
  Hash $config = {},
  Boolean $force_update = false,
) {

  $config_file =  "/etc/NetworkManager/conf.d/${config_file_name}"

  file { $config_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $force_update? { true => '', default => undef },
    notify  => Service[$nm_service_name]
  }

  $defaults = { 'path' => $config_file, 'key_val_separator' => '=', notify => Service[$nm_service_name] }
  inifile::create_ini_settings($config, $defaults)


}