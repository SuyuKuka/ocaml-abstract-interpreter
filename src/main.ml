open Read;;
open Display;;
open Exec;;

let main () =
  let command = Read.read_cmd () 
  in configure_display command;
  (* let state = init_state program { x = 0.0; y = 0.0 }
  in run_program state 0.5; *)
;;
