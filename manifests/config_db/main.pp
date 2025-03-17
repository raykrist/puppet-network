#
class network::config_db::main(
  String $config_db_file,
  Boolean $json_skip_undef,
  Hash $json_opts,
  Hash $interfaces_hash = $network::interfaces_hash,
  Hash $default_interfaces_hash = $network::default_interfaces_hash,
) {

  require network::config_db::setup

  $real_interfaces_hash = deep_merge($interfaces_hash, $default_interfaces_hash)

  if $network::reload {
    $notify = Exec["reload_config"]
  } else {
    $notify = undef
  }

  concat { "${config_db_file}":
    ensure => present,
    validate_cmd => '/usr/local/bin/sonic-cfggen -j %',
    notify => $notify
  }

  concat::fragment { 'config_db':
    target  => $config_db_file,
    content => to_json_pretty($real_interfaces_hash, $json_skip_undef, $json_opts),
    order   => '01'
  }

  exec { "reload_config":
    command     => "/usr/local/bin/config reload ${config_db_file} -y",
    group       => 'root',
    user        => 'root',
    refreshonly => true,
  }

}
