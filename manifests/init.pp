class nfs_autofs_prep {

  $filesrc = "# Managed by puppet\n# This file is created on all fileservers managed by puppet\n# It stores all nfs mount mappings to tags, also used for automounts mappings"
  file { '/var/sandbox/nfsmounts':
    ensure  => file,
    content => $filesrc,
    replace => no,
  }

  $sharenames = query_resources(false, ['and',['=', 'type', 'Nfs::Server::Export::Configure'],['not',['=', 'tag', 'undef']]], false)

  # DO NOT modify this line to make it mutiple readable lines, inline_templates introduce spaces whenever whitespace is available at all
  $sharenames_count = inline_template('<%- count = 0 -%><%- sharenames.each do |source_key| -%><%= count -%>,<%- count = count.to_i + 1 -%><%- end -%>')
  $sharenames_count_array = split($sharenames_count, ',') 


  nfs_autofs_prep::parse_write { $sharenames_count_array: 
    array_dump => $sharenames,
  }
}
