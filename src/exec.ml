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

(* let execute_step state =
  match state.remaining with
  | [] -> None
  | instr :: rest ->
      let new_position = match instr with
        | Interp.Move transform -> Geo.transform transform state.position
        | _ -> state.position (* Gérer Repeat et Either *)
      in
      let new_state = { state with position = new_position; remaining = rest } in
      Some new_state
;;

let rec run_program state delay =
  match execute_step state with
  | None -> () 
  | Some new_state ->
    Graphics.clear_graph ();
    (* draw_point new_state.position; *)
    Unix.sleepf delay;
    run_program new_state delay
;; *)