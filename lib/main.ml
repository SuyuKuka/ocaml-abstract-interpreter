open Geo;;
open Read;;
open Display;;
open Exec;;
open Utils;;

let main () =
  let command = Read.read_cmd () 
  in configure_display command;

<<<<<<< HEAD:lib/main.ml
  let selected_prog =
=======
  (* let state = init_state program { x = 0.0; y = 0.0 }
  in run_program state 0.5; *)
  
  (*let selected_prog = (* Idéal dans main ? *)
>>>>>>> 3614463 (Commentaires indicatifs f):src/main.ml
    match command.program with
    | "1" -> program1()
    | "2" -> program2()
    | "3" -> program3()
    | _ -> failwith "Programme sélectionné invalide."
  in
  let initial_state = Exec.init_state selected_prog { x = 0.0; y = 0.0 } 
  in Exec.run_program initial_state 1.;

<<<<<<< HEAD:lib/main.ml
  close ();
=======
  let initial_state = Exec.init_state selected_prog { x = 0.0; y = 0.0 } in
  Exec.run_program initial_state 0.5;

  exit 0
  *)
>>>>>>> 3614463 (Commentaires indicatifs f):src/main.ml
;;
