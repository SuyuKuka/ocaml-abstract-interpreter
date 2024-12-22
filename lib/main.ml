open Geo;;
open Read;;
open Display;;
open Exec;;
open Utils;;

let main () =
  let command = Read.read_cmd () 
  in configure_display command;

  (* let state = init_state program { x = 0.0; y = 0.0 }
  in run_program state 0.5; *)
  
  (*let selected_prog = (* Idéal dans main ? *)
    match command.program with
    | "1" -> program1()
    | "2" -> program2()
    | "3" -> program3()
    | _ -> failwith "Programme sélectionné invalide."
  in

  let initial_state = Exec.init_state selected_prog { x = 0.0; y = 0.0 } in
  Exec.run_program initial_state 0.5;

  exit 0
  *)
;;
