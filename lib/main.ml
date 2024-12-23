<<<<<<< HEAD:lib/main.ml
open Geo;;
open Read;;
open Display;;
open Exec;;
open Utils;;

let main () =
  let command = Read.read_cmd () 
  in configure_display command;

<<<<<<< HEAD:lib/main.ml
<<<<<<< HEAD:lib/main.ml
<<<<<<< HEAD:lib/main.ml
  let selected_prog =
=======
  (* let state = init_state program { x = 0.0; y = 0.0 }
  in run_program state 0.5; *)
  
  (*let selected_prog = (* Idéal dans main ? *)
>>>>>>> 3614463 (Commentaires indicatifs f):src/main.ml
=======
  (* 
  PB : tout se passe dès configure_display command; tout ce qu'il y a après dans le main n'est pas compris.
  L'appel de configure_display command ouvre notre fenêtre graphique, et se termine quand l'user appuie sur une touche pour fermer la fenêtre.
  Tout ce qui se situe dans le main après cette ligne n'est "exécuté" que après que la fenêtre soit fermée, ce qui cause les erreurs.
  *)

=======
>>>>>>> 181c66a (Logique exécution des programmes (pb de repeat résolu), reste affichage):src/main.ml
  let selected_prog =
>>>>>>> c3b4855 (Pb de bloquage fenêtre trouvé, juste pb d'affichage):src/main.ml
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

<<<<<<< HEAD:lib/main.ml
<<<<<<< HEAD:lib/main.ml
  exit 0
  *)
>>>>>>> 3614463 (Commentaires indicatifs f):src/main.ml
=======
  (* Laisser la fenêtre ouverte jusqu'à ce qu'une touche soit pressée *)
  print_endline "Programme terminé. Appuyez sur une touche pour fermer.";
=======
  (* Laisser la fenêtre open jusqu'à ce qu'une touche soit pressée *)
  print_endline "Programme terminé. Appuyez sur une touche du clavier pour fermer.";
>>>>>>> 181c66a (Logique exécution des programmes (pb de repeat résolu), reste affichage):src/main.ml
  ignore (Graphics.read_key ());
  Graphics.close_graph ();
>>>>>>> c3b4855 (Pb de bloquage fenêtre trouvé, juste pb d'affichage):src/main.ml
;;
=======
open Geo
open Read
open Display
open Exec
open Utils

let main () =
  let command = Read.read_cmd () 
  in let display = configure_display command false 
  in let selected_prog =
    match command.program with
    | "1" -> program1 ()
    | "2" -> program2 ()
    | "3" -> program3 ()
    | _ -> failwith "Programme sélectionné invalide."
  in

  if List.length command.options = 0 then (
    (* Sans options *)
    draw_point display.width display.height display.scale command;
    let initial_state = init_state selected_prog { x = 0.0; y = 0.0 } in
    run_program initial_state 1. command
  )
  else (
    (* Point*)
    let () = 
      match List.find_opt (fun opt -> opt.name = "-cr") command.options with
      | Some _ ->
        draw_point display.width display.height display.scale command;
        let initial_state = init_state selected_prog { x = 0.0; y = 0.0 } 
        in run_program initial_state 1. command
      | None -> ()
    in 
    let () =
      match List.find_opt (fun opt -> opt.name = "-abs") command.options with
      | Some abs_option -> 
        (match abs_option.arguments with
        | [x_min; y_min; x_max; y_max] -> 
          let x_min = int_of_string x_min
          and y_min = int_of_string y_min
          and x_max = int_of_string x_max
          and y_max = int_of_string y_max 
          in
          if not (x_min <= 0 && 0 <= x_max && y_min <= 0 && 0 <= y_max) then
            failwith "Rectangle must contain (0,0)"
          else
            draw_rectangle { 
              x_min = float_of_int (x_min * display.scale + display.width / 2); 
              x_max = float_of_int (x_max * display.scale + display.width / 2); 
              y_min = float_of_int (y_min * display.scale + display.height / 2); 
              y_max = float_of_int (y_max * display.scale + display.height / 2); 
            } display.scale command;
          let initial_state_rect = init_state_rect selected_prog { x_min = float_of_int x_min; x_max = float_of_int x_max; y_min = float_of_int y_min; y_max = float_of_int y_max } 
          in run_program_rect initial_state_rect 1. command;
        | _ -> failwith "Invalid arguments for -abs")
      | None -> ();
    in ();
  );

  close ()
;;
>>>>>>> d2565a8253cf41a78a0a3095b981e0df89e3652c:src/main.ml
