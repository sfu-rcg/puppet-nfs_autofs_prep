(* Nfstest module for Augeas
 Author: Adam S <asa188@sfu.ca>

*)


module Nfstest =
  autoload xfm
(************************************************************************
 *                           USEFUL PRIMITIVES
 *************************************************************************)

let eol    = Util.eol

(* Define separators *)
let sepc (pat:regexp) (default:string)
                       = Sep.opt_space . del pat default

let sep_eq    = sepc "=" "="
let sep_comma    = sepc "," ","
let comma_opt_nil = del /[ \t]+?,+?[ \t]+?/ ""
let comma_opt_comma = del /[ \t]+?,+?[ \t]+?/ ", "
let sep_lsbracket  = sepc "[ " "[ "
let sep_rsbracket  = sepc " ]" " ]"

(* Define value regexps *)
let an_re  = /[a-z0-9_\-]*/
let fs_re  = /[A-Za-z0-9\/\:\._\-]+/ 

(* Define store aliases *)
let fs_alias = store fs_re

(* define comments and empty lines *)
let comment = Util.comment_generic /[ \t]*[;#][ \t]*/ "# "
let comment_or_eol = eol | Util.comment_generic /[ \t]*[;#][ \t]*/ " # "

let empty   = Util.empty

let single_an  = "owner"

let single_entry (kw:regexp) (re:regexp)
               = [ key kw . sep_eq . store re . comment_or_eol ]

let single_own = single_entry single_an  an_re


(*** Items from build.aug  ******)

let opt_list (lns:lens) (sep:lens) = lns . ( sep . lns )*

let key_value_line_brackets (kw:regexp) (sep:lens) (sto:lens) (ls_bracket:lens) (rs_bracket:lens) =
                                   [ key kw . sep . ls_bracket . sto . rs_bracket . eol ]

let key_value_line (kw:regexp) (sep:lens) (sto:lens) =
                                   [ key kw . sep . sto . eol ]


let fs (kw:regexp) (sq:string) =
                    let value = fs_alias in 
                    [ key kw . sep_eq . sep_lsbracket 
                    . [ label "server" . [ seq sq . comma_opt_nil . value ]* ] . sep_rsbracket . comment_or_eol
		    ]

let entry_list_nocomment (kw:regexp) (sep:lens) (sto:regexp) (list_sep:lens) =
  let list = counter "elem"
      . opt_list [ seq "elem" . store sto ] list_sep
  in key_value_line kw sep (Sep.opt_space . list)

let other         = fs "FS" "servername"
let otherlist         = entry_list_nocomment "FS" sep_eq fs_re comma_opt_comma


(************************************************************************
 *                              LENS & FILTER
 *************************************************************************)
(************************************************************************
 *                        ENTRY
 * puppet.conf uses standard INI File entries
 *************************************************************************)
let entry   = IniFile.indented_entry /[a-b]+/ sep_eq comment


(************************************************************************
 *                        RECORD
 * puppet.conf uses standard INI File records
 *************************************************************************)
let title   = IniFile.title ( IniFile.record_re - ".comments" )
let record  = IniFile.record title ( single_own | otherlist | entry )

let record_anon = [ label ".comments" . ( entry | empty )+ ]

let lns = record_anon? . record* 

let filter = (incl "/var/sandbox/nfsmounts")

let xfm = transform lns filter
