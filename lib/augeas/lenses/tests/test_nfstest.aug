(* Puppet module for Augeas
 Author: Raphael Pinson <raphink@gmail.com>

 puppet.conf is a standard INI File.
*)


module Test_nfstest =

let conf   = "# Managed by puppet
[ensc-image]
owner=jpeltier
FS=[ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON,ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON]
"

let conf2   = "# TEST2 Managed by puppet
[ensc-image]
owner=jpeltier
FS=[ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON , ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON]
"

let confp   = "set ensc-image/FS/server/0 ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON"


test Nfstest.lns get conf = ?
test Nfstest.lns get conf2 = ?
test Nfstest.lns put conf after set "ensc-image/FS/server/0" "ensc-mial-fs99.ensc.sfu.ca:/srv/NEWTON" = ?
