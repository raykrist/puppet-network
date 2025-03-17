#
define network::interfaces::connection(
  Enum['present', 'absent'] $ensure = 'present',
  String $interface = $name,
  String $stanza = 'iface',
  Boolean $auto = true,
  String $family = '',
  String $method = '',
  Boolean $allow_hotplug = false,
  Hash $config = {},
  String $template = "${module_name}/interfaces/iface.erb"
) {

  require network::interfaces::setup

  $config_file =  "/etc/network/interfaces.d/${name}"

  if $network::debug {
    info("DEBUG:create config file ${config_file}")
  }
  file { "interface-${name}":
    ensure  => $ensure,
    path    => "/etc/network/interfaces.d/${name}",
    content => template($template),
    notify  => Exec["reload_${name}"]
  }

  exec { "reload_${name}":
    command     => network::reload_interface($name, $network::reload),
    group       => 'root',
    user        => 'root',
    refreshonly => true,
  }

}
