#
class network::nm::setup(
  Hash $packages,
  String $nm_service_name,
  Hash $nm_custom_config,
) {

  if $::network::manage_services {
    service { $nm_service_name:
      ensure => 'running',
      enable => true
    }
  }

  create_resources('package', $packages)
  create_resources('network::nm::config', $nm_custom_config)

}
