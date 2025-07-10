#
define network::nm::connection(
  Enum['present', 'absent'] $ensure = 'present',
  String $id = $name,
  String $connection_type = 'ethernet',
  String $interface_name = $name,
  String $autoconnect = 'true',
  Optional[String] $controller = undef,
  Optional[String] $port_type = 'bridge',
  Hash $ethernet = {},
  Hash $ipv4 = { 'method' => 'disabled' },
  Hash $ipv6 = { 'method' => 'disabled' },
  Hash $vlan = {},
  Boolean $force_update = false,
) {

  require network::nm::setup

  $config_file =  "/etc/NetworkManager/system-connections/${id}.nmconnection"
  if fact("nm_connections.${id}.uuid") {
    $uuid = $facts['nm_connections'][$id]['uuid']
  } else {
    $uuid = network::uuid($id)
  }

  # if force_update, remove contents of config file
  file { $config_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $force_update? { true => '', default => undef }
  }

  if $ensure == 'present' {
    $settings = {
      'connection' => {
        'uuid' => $uuid,
        'id' => $id,
        'interface-name' => $interface_name,
        'type' => $connection_type,
        'autoconnect' => $autoconnect
      },
      'ethernet' => $ethernet,
      'ipv4' => $ipv4,
      'ipv6' => $ipv6,
      'vlan' => $vlan
    }
    if $controller {
      $settings_controller = {
        # Use master/slave-type for backward compatibility
        'connection' => {
          'master' => $controller,
          'slave-type' => $port_type
        }
      }
    } else {
      $settings_controller = {}
    }

    $settings_real = deep_merge($settings, $settings_controller)

    $defaults = { 'path' => $config_file, 'key_val_separator' => '=', notify => Exec["reload_${uuid}"] }
    inifile::create_ini_settings($settings_real, $defaults)

    exec { "reload_${uuid}":
      command     => network::nm_reload_connection($uuid, 'up', $network::reload),
      group       => 'root',
      user        => 'root',
      refreshonly => true,
    }
  }
}
