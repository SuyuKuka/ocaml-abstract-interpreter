type state = {
  position : Geo.point;
  program : Interp.program;
  reset : Interp.program;
}

val init_state : Interp.program -> Geo.point -> state
val execute_step : state -> state option
val run_program : state -> float -> unit