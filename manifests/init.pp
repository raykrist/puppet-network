#
class network(
  Boolean $reload,
  String $interfaces_type,
  Hash $interfaces_hash = {},
  Hash $default_interfaces_hash = {},
) {

  info($interfaces_hash)
  info($default_interfaces_hash)

  if $interfaces_type {
    create_resources("${name}::${interfaces_type}", $interfaces_hash, $default_interfaces_hash)
  }
}
