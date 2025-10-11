#
# This class will add helper scripts to
# * take down all endpoint ports
# * take up all endpoint ports,
# ports matching 'desc_filter' or has 'admin_status' down will be excluded!
#
class network::config_db::scripts(
  Enum['present', 'absent'] $ensure = 'present',
  Array $desc_filter = ["peerlink", "downlink", "uplink"],
  Hash $interfaces_hash = $network::interfaces_hash,
  Hash $default_interfaces_hash = $network::default_interfaces_hash,
) {

  $real_interfaces_hash = deep_merge($interfaces_hash, $default_interfaces_hash)
  $ports = $real_interfaces_hash['PORT'].map |$port, $config| {
    unless $desc_filter.any |$element| { $element in $config['description'] } {
      if $config['admin_status'] == 'up' { $port }
    }
  }

  # this will include a list of ports we want to take down and up controlled
  $endpoint_ports = delete_undef_values($ports)

  file { "down_ports.py":
    ensure  => $ensure,
    path    => "/usr/local/bin/down_ports.py",
    owner   => "root",
    mode    => '0700',
    content => template("${module_name}/config_db/down_ports.py.erb"),
  }

  file { "up_ports.py":
    ensure  => $ensure,
    path    => "/usr/local/bin/up_ports.py",
    owner   => "root",
    mode    => '0700',
    content => template("${module_name}/config_db/up_ports.py.erb"),
  }

}
