function network::nm_reload_connection(
  String $id,
  String $state
) >> String {

  $command = '/usr/bin/nmcli connection reload && /usr/bin/nmcli connection'
  "${command} ${state} ${id}"
}
