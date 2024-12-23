<<<<<<< HEAD:lib/display.mli
type display = {
  width : int;
  height : int;
  scale : int;
}
val draw_axes : int -> int -> int -> unit
val draw_point : int -> int -> int -> Read.command -> unit
val draw_rectangle : Geo.rectangle -> int -> Read.command -> unit
val init_window : int -> int -> Read.command -> bool -> unit
val configure_display : Read.command -> bool -> display
=======
type display = {
  width : int;
  height : int;
  scale : int;
}
val draw_axes : int -> int -> int -> unit
val draw_point : int -> int -> int -> Read.command -> unit
val draw_rectangle : Geo.rectangle -> int -> Read.command -> unit
val init_window : int -> int -> Read.command -> bool -> unit
val configure_display : Read.command -> bool -> display
>>>>>>> d2565a8253cf41a78a0a3095b981e0df89e3652c:src/display.mli
val close : unit -> unit