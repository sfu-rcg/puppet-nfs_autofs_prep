(* OpenVPN module for Augeas
 Author: Raphael Pinson <raphink@gmail.com>

 Reference: http://openvpn.net/index.php/documentation/howto.html
*)


module Nfstest =
(************************************************************************
 *                           USEFUL PRIMITIVES
 *************************************************************************)

let peol    = del /\n*/ "" 
let eol    = Util.eol
let indent = Util.indent

(* Define separators *)
let sep    = Util.del_ws_spc
let sepc (pat:regexp) (default:string)
                       = Sep.opt_space . del pat default

let sep_eq    = sepc "=" "="
let sep_comma      = del (Rx.opt_space . "," . Rx.opt_space) ","
let sep_comma_old    = del /,[ \t]*/ ", " 
let sep_comma_short    = del /[,]+/ ","
let sep_colon    = del ":" ":" 
let colon_opt_nil  = del /\:+?/ "" 
let comma_opt_nil = del /[ \t]+?,+?[ \t]+?/ ","
let sep_lsbracket  = sepc "[" "["
let sep_rsbracket  = sepc "]" "]"

(* Define value regexps *)
let ip_re  = Rx.ipv4
let num_re = Rx.integer
let fn_re  = /[^#; \t\n][^#;\n]*[^#; \t\n]|[^#; \t\n]/
let an_re  = /[a-z0-9_\-]*/
(*let fs_re  = /[A-Za-z0-9._\-]+[^\:]*/ *)
let fs_re  = /[A-Za-z0-9\/\:\._\-]*/ 
let fs_re_comma  = ( /[A-Za-z0-9\/\:\._\-]+[,]+/ )
(*let fs_re  = /[^\:]*/*)
(* let fs_re  = /[A-Za-z0-9\.\-_][^\:,\/]*/ *)
let share_re  = /[A-Za-z\/0-9\._]*/

let comma_re = del /,?[ \t]+[^[A-Za-z\/0-9._]*]*/ ", "

(* Define store aliases *)
let ip     = store ip_re
let num    = store num_re
let filename = store fn_re
let fs_alias = store fs_re
let fs_alias_comma = store fs_re_comma
let share_alias = store share_re
let sto_to_dquote = store /[^"\n]+/   (* " Emacs, relax *)

(* define comments and empty lines *)
let comment = Util.comment_generic /[ \t]*[;#][ \t]*/ "# "
let comment_or_eol = eol | Util.comment_generic /[ \t]*[;#][ \t]*/ " # "

let empty   = Util.empty

let single_an  = "owner"

let single_entry (kw:regexp) (re:regexp)
               = [ key kw . sep_eq . store re . comment_or_eol ]

let single_own = single_entry single_an  an_re


let fs (kw:regexp) (sq:string) =
                    let value = fs_alias in 
                    [ key kw . sep_eq . sep_lsbracket
                    . [ label "server" . [ seq "servername" . comma_opt_nil . value ]* ] . sep_rsbracket . comment_or_eol
		    ]

let other         = fs "FS" "servername"


(************************************************************************
 *                              LENS & FILTER
 *************************************************************************)
(************************************************************************
 *                        ENTRY
 * puppet.conf uses standard INI File entries
 *************************************************************************)
(*let entry   = IniFile.indented_entry IniFile.entry_re sep_eq comment *)
let entry   = IniFile.indented_entry /[a-b]+/ sep_eq comment


(************************************************************************
 *                        RECORD
 * puppet.conf uses standard INI File records
 *************************************************************************)
let title   = IniFile.title ( IniFile.record_re - ".enscimage" )
let record  = IniFile.record title ( single_own | other | entry )

let record_anon = [ label ".enscimage" . ( entry | empty )+ ]

(*let lns    = ( comment | empty | single | flag | other )*  *)
let lns = record_anon? . record* 
