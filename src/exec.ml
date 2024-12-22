open Geo;;
open Interp;;
open Display;;

type state = {
  position : point;
  program : program;
  reset : program;
}

let init_state (prog : program) (p : point) : state = 
  {
  position = p;
  program = prog;
  reset = prog;
  }
;;

let execute_step state =
  match state.program with
  | [] -> None
  | instr :: rest ->
      let new_position, new_program = match instr with
        | Interp.Move transform -> Geo.transform transform state.position, rest
        | Interp.Repeat (n, sub_prog) ->
          if n>1 then
            let repeated = Interp.Repeat(n-1, sub_prog) in
            state.position, sub_prog @ (repeated :: rest)
          else
            state.position, rest
        | Interp.Either (choice1, choice2) ->
          state.position, choice1 @ rest
      in
      let new_state = { state with position = new_position; program = new_program } in
      Some new_state
;;

let rec run_program state delay =
  match execute_step state with
  | None -> () 
  | Some new_state ->
    Graphics.clear_graph ();
    Display.draw_point 
      (int_of_float new_state.position.x)
      (int_of_float new_state.position.y);

    Unix.sleepf delay;
    run_program new_state delay
;;