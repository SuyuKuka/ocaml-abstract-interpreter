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
              x_min = float_of_int (x_min + display.width / 2); 
              x_max = float_of_int (x_max + display.width / 2); 
              y_min = float_of_int (y_min + display.height / 2); 
              y_max = float_of_int (y_max + display.height / 2); 
            } display.scale command;
          | _ -> failwith "Invalid arguments for -abs")
      | None -> ();
    in ();
  );

  close ()
;;