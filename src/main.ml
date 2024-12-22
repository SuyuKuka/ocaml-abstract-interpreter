open Geo;;
open Read;;
open Display;;
open Exec;;
open Utils;;

let main () =
  let command = Read.read_cmd () 
  in configure_display command;

  let selected_prog =
    match command.program with
    | "1" -> program1()
    | "2" -> program2()
    | "3" -> program3()
    | _ -> failwith "Programme sélectionné invalide."
  in

  let initial_state = Exec.init_state selected_prog { x = 0.0; y = 0.0 } in
  Exec.run_program initial_state 0.5;

  (* Laisser la fenêtre open jusqu'à ce qu'une touche soit pressée *)
  print_endline "Programme terminé. Appuyez sur une touche du clavier pour fermer.";
  ignore (Graphics.read_key ());
  Graphics.close_graph ();
;;
