#
# class to manage custom routing table in /etc/iproute2/rt_tables
#
class network::routing::table(
  String $ensure = 'present',
  String $path = '/etc/iproute2/rt_tables',
  Hash $tables = {},
  String $template = "${module_name}/routing/rt_tables.erb"
) {

  file { dirname($path):
    ensure => $ensure ? { 'present' => 'directory', default => 'absent'},
    force  => true
  }

  file { $path:
    ensure  => $ensure,
    path    => $path,
    content => template($template)
  }

}
