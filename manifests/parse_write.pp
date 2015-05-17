define nfs_autofs_prep::parse_write($array_dump = [],$file = '/var/sandbox/nfsmounts') {
  $result_certname = $array_dump[$name]['certname']
  $result_title    = $array_dump[$name]['title']
  $result_tag      = $array_dump[$name]['parameters']['tag']

  # Not needed right now but for debugging purposes if needed.
  #notify { "\n Tag      = ${result_tag} \n Certname = ${result_certname} \n Title    = ${result_title} \n /files${file}": }

  augeas { "${result_tag} ${result_certname} ${result_title}":
    lens    => 'Puppet.lns',
    incl    => $file,
    require => File["${file}"],
    context => "/files${file}",
    changes => [ "set $result_tag/$result_certname $result_title" ]
  }
}