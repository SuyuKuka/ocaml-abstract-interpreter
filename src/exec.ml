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

let execute_step state = (* Check si étapes bien réalisées, rajouter logs ? *)
  match state.program with
  | [] -> None
  | instr :: rest ->
      let new_position, new_program = match instr with
        | Interp.Move transform -> Geo.transform transform state.position, rest (* Cas Move: juste transform la position *)
        | Interp.Repeat (n, sub_prog) ->  (* Cas Repeat: on répète n fois le programme avant de return la position de fin *)
          if n > 1 then
            let repeated = Interp.Repeat(n-1, sub_prog) in
            state.position, sub_prog @ (repeated :: rest)
          else
            state.position, rest
        | Interp.Either (choice1, choice2) -> (* Cas Either: choix 1 mis par défaut, implémenter random après ? *)
          state.position, choice1 @ rest
      in
      let new_state = { state with position = new_position; program = new_program } in
      Some new_state
;;

let rec run_program state delay = (* fait de Graphics.clear_graph casse tout ou bad logique d'exec ? *)
  try
    match execute_step state with
    | None -> () (* Programme fini *)
    | Some new_state -> (* Draw que si la fenêtre est ouverte *)
        (*Graphics.clear_graph ();*)
        print_endline "Exécution d'une étape du prog :";
        Display.draw_point 
          (int_of_float new_state.position.x)
          (int_of_float new_state.position.y);

        Unix.sleepf delay;
        run_program new_state delay
  with
  | Graphics.Graphic_failure _ -> 
      print_endline "Erreur graphique : la fenêtre a été fermée.";
      ()
;;