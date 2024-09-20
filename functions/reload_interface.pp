function network::reload_interface(
  String $id,
  Boolean $reload,
) >> String {
  if $reload { # reload connection and set state for id
    "/usr/sbin/ifdown ${id}; /usr/sbin/ifup ${id}"
  } else { # when reload is false, just run /bin/true
    '/bin/true'
  }
}
