open Read;;
open Display;;

let main () =
  let command = Read.read_cmd () in

  let (width, height) =
    match List.find_opt (fun opt -> opt.name = "-size") command.options with
    | Some size_option ->
        (match size_option.arguments with
         | [w; h] -> (int_of_string w, int_of_string h)
         | _ -> failwith "Invalid arguments")
    | None -> (600, 400)
  in init_window width height;
  draw_point 100 100;
;;
