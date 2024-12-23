<<<<<<< HEAD:lib/exec.mli
type state = {
  position : Geo.point;
  program : Interp.program;
  reset : Interp.program;
}
type state_rect = {
  rect : Geo.rectangle;
  program : Interp.program;
  reset : Interp.program;
}
val init_state : Interp.program -> Geo.point -> state
val init_state_rect : Interp.program -> Geo.rectangle -> state_rect
val execute_step : state -> state option
val execute_step_rect : state_rect -> state_rect option
val run_program : state -> float -> Read.command -> unit
=======
type state = {
  position : Geo.point;
  program : Interp.program;
  reset : Interp.program;
}
type state_rect = {
  rect : Geo.rectangle;
  program : Interp.program;
  reset : Interp.program;
}
val init_state : Interp.program -> Geo.point -> state
val init_state_rect : Interp.program -> Geo.rectangle -> state_rect
val execute_step : state -> state option
val execute_step_rect : state_rect -> state_rect option
val run_program : state -> float -> Read.command -> unit
>>>>>>> d2565a8253cf41a78a0a3095b981e0df89e3652c:src/exec.mli
val run_program_rect : state_rect -> float -> Read.command -> unit