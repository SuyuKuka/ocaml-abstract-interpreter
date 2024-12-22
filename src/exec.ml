open Geo;;
open Interp;;
open Display;;
open Graphics;;

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
        | Move transform -> Geo.transform transform state.position, rest (* Cas Move: juste transform la position *)
        | Repeat (n, sub_prog) ->  (* Cas Repeat: on répète n fois le programme avant de return la position de fin ? *)
          if n > 1 then
            state.position, [Repeat (n - 1, sub_prog)] @ rest
          else
            state.position, rest
        | Either (choice1, choice2) -> (* Cas Either: choix 1 mis par défaut, implémenter random après ? *)
          state.position, choice1 @ rest
      in
      let new_state = { state with position = new_position; program = new_program } in
      Some new_state
;;

let rec run_program (state : state) (delay : float) (cmd : Read.command) : unit = 
  match execute_step state with
  | None -> () 
  | Some new_state -> 
      print_endline "Exécution d'une étape du prog :";
      Unix.sleepf delay;
      let display = configure_display cmd true
      in 
      let (x, y) =
        ( 
          ((new_state.position.x *. 2.) *. float_of_int display.scale) +. float_of_int display.width,
          ((new_state.position.y *. 2.) *. float_of_int display.scale) +. float_of_int display.height
        )
      in draw_point (int_of_float x) (int_of_float y) display.scale cmd;
      run_program new_state delay cmd
;;