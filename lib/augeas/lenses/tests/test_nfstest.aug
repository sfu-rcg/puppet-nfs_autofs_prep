(* Puppet module for Augeas
 Author: Raphael Pinson <raphink@gmail.com>

 puppet.conf is a standard INI File.
*)


module Test_nfstest =

let conf   = "# Managed by puppet - no BRACKETS
[ensc-image]
owner=jpeltier
FS=ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON,ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON
"

let conf2   = "# Managed by puppet - BRACKETS no spaces
[ensc-image]
owner=jpeltier
FS=[ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON,ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON]
"

let conf3   = "# TEST2 Managed by puppet - BRACKETS comma-spaces
[ensc-image]
owner=jpeltier
FS=[ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON , ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON]
"

let conf4   = "# Managed by puppet
[ensc-image]
owner=jpeltier
"

let conf5   = "# Managed by puppet - no BRACKETS - comma-spaces
[ensc-image]
owner=jpeltier
FS=ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON , ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON
"
let conf6   = "# Managed by puppet - BRACKETS-spaces no spaces
[ensc-image]
owner=jpeltier
FS=[ ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON,ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON ]
"

let conf7   = "# TEST2 Managed by puppet - BRACKETS-spaces comma-spaces
[ensc-image]
owner=jpeltier
FS=[ ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON , ensc-mial-fs02.ensc.sfu.ca:/srv/NEWTON ]
"

let confp   = "set ensc-image/FS/server/0 ensc-mial-fs01.ensc.sfu.ca:/srv/NEWTON"


test Nfstest.lns get conf = ?
test Nfstest.lns get conf5 = ?
test Nfstest.lns put conf4 after set "ensc-image/FS/01" "ensc-mial-fs99.ensc.sfu.ca:/srv/NEWTON"; set "ensc-image/FS/0" "ensc-mial-fs90.ensc.sfu.ca:/srv/NEWTON" = ?
