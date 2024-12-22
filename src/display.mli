val draw_axes : int -> int -> int -> unit
val draw_point : int -> int -> int -> Read.command -> unit
val draw_rectangle : Geo.rectangle -> int -> Read.command -> unit
val init_window : int -> int -> Read.command -> unit
val configure_display : Read.command -> unit
val close : unit -> unit