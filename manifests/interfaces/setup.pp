#
class network::interfaces::setup(
  Boolean $addon_script_support,
  Boolean $vlan,
  Array[Optional[String]] $packages,
) {

  info('setup interfaces!!')
  info($addon_script_support)

  package { 'vlan':
    ensure => $vlan
  }

  package { $packages:
    ensure => present
  }

  file_line { "${name}_allow_addon_scripts_support":
    ensure => $addon_script_support? { true => 'present', default => 'absent'},
    path   => '/etc/network/ifupdown2/ifupdown2.conf',
    line   => 'addon_scripts_support=1',
    match  => 'addon_scripts_suppor*',
    #notify => $network_notify,
  }
  # file_line { 'use ':
  #   ensure => 'present',
  #   path   => '/etc/network/interfaces',
  #   line   => 'source /etc/network/interfaces.d/*',
  #   #notify => $network_notify,
  # }
  # file { '/etc/network/interfaces.d':
  #   ensure => 'directory',
  #   mode   => '0755',
  #   owner  => 'root',
  #   group  => 'root',
  # }


}
