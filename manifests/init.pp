#
class network(
  Boolean $reload,
  Boolean $debug,
  String $interfaces_type,
  Boolean $use_config_class,
  Boolean $manage_services,
  Hash $interfaces_hash = {},
  Hash $default_interfaces_hash = {},
) {

  if $debug {
    info("DEBUG:interfaces_hash=${interfaces_hash}")
    info("DEBUG:default_interfaces_hash=${default_interfaces_hash}")
  }

  # set $use_config_class to true to allow using config classes
  unless $use_config_class {
    create_resources("${name}::${interfaces_type}", $interfaces_hash, $default_interfaces_hash)
  } else {
    include "::${name}::${interfaces_type}"
  }
}
