open Geo;;
open Read;;
open Display;;
open Exec;;
open Utils;;

let main () =
  let command = Read.read_cmd () 
  in ignore (configure_display command false); 
  
  let selected_prog =
    match command.program with
    | "1" -> program1()
    | "2" -> program2()
    | "3" -> program3()
    | _ -> failwith "Programme sélectionné invalide."
  in
  let initial_state = init_state selected_prog { x = 0.0; y = 0.0 } 
  in run_program initial_state 1. command;

  close ();
;;