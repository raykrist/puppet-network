function network::nm_reload_connection(
  String $id,
  Enum['up', 'down'] $state,
  Boolean $reload,
) >> String {
  if $reload { # reload connection and set state for id
    $command = '/usr/bin/nmcli connection reload && /usr/bin/nmcli connection'
    "${command} ${state} ${id}"
  } else { # when reload is false, just run /bin/true
    '/bin/true'
  }
}
