<<<<<<< HEAD:lib/read.mli
type option = {
  name : string; 
  arguments : string list; 
}
type command = {
  cmd : string; 
  options : option list; 
  program : string; 
}
val is_digit_only : string -> bool
val remove : int -> string list -> string list
val take : int -> string list -> string list
val extract_opt : int -> string list -> string list * string list
val parse_options : string list -> option list
val parse_command : string list -> command
val read_cmd : unit -> command
=======
type option = {
  name : string; 
  arguments : string list; 
}
type command = {
  cmd : string; 
  options : option list; 
  program : string; 
}
val is_digit_only : string -> bool
val remove : int -> string list -> string list
val take : int -> string list -> string list
val extract_opt : int -> string list -> string list * string list
val parse_options : string list -> option list
val parse_command : string list -> command
val read_cmd : unit -> command
>>>>>>> d2565a8253cf41a78a0a3095b981e0df89e3652c:src/read.mli
