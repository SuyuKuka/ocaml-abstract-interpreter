open Graphics;;
open Read;;
open Geo;;

let draw_axes (width : int) (height : int) (scale : int) : unit =
  let center_x = width / 2
  in let center_y = height / 2 
  in set_color black;

  moveto 0 center_y;
  lineto width center_y;

  moveto center_x 0;
  lineto center_x height;

  for x = 0 to width do
    if (x - center_x) mod (scale) = 0 then (
      moveto x (center_y - 5);
      lineto x (center_y + 5);

      moveto (x - 5) (center_y - 25);
      let value = float_of_int ((x - center_x) / scale) 
      in if x <> center_x then 
        draw_string (string_of_float value)
    )
  done;

  for y = 0 to height do
    if (y - center_y) mod (scale) = 0 then (
      moveto (center_x - 5) y;
      lineto (center_x + 5) y; 

      moveto (center_x - 25) y;
      let value = float_of_int ((y - center_y) / scale)
      in if y <> center_y then 
        draw_string (string_of_float value)
    )
  done;

  moveto (center_x + 10) (center_y - 10);
;;

let draw_point (x : int) (y : int) : unit =
  set_color blue;
  fill_circle x y 5
;;

let draw_rectangle (rect : rectangle) : unit =
  set_color red;
  draw_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min))
;;

let init_window (width : int) (height : int) (cmd : command) : unit =
  open_graph (" " ^ string_of_int width ^ "x" ^ string_of_int height);
  set_window_title "Exececution pas a pas du programme";
  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-bc") cmd.options with
    | Some color_option ->
        (match color_option.arguments with
        | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
        | _ -> failwith "Invalid arguments")
    | None -> (255, 255, 255)
  in let background_color = rgb r g b in
  set_color background_color; 
  fill_rect 0 0 width height;

  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-fc") cmd.options with
    | Some color_option ->
        (match color_option.arguments with
         | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
         | _ -> failwith "Invalid arguments")
    | None -> (0, 0, 0)
  in set_color (rgb r g b);

  draw_axes width height 100;

  ignore (read_key ());
  close_graph ()
;;

let configure_display (cmd : command) : unit =
  let (width, height) =
    match List.find_opt (fun opt -> opt.name = "-size") cmd.options with
    | Some size_option ->
        (match size_option.arguments with
         | [w; h] -> (int_of_string w, int_of_string h)
         | _ -> failwith "Invalid arguments for -size")
    | None -> (1500, 900)
  in init_window width height cmd;

  let (x_min, y_min, x_max, y_max) =
    match List.find_opt (fun opt -> opt.name = "-abs") cmd.options with
    | Some abs_option -> 
        (match abs_option.arguments with
        | [x_min; y_min; x_max; y_max] ->
            let x_min = int_of_string x_min
            and y_min = int_of_string y_min
            and x_max = int_of_string x_max
            and y_max = int_of_string y_max in
            if not (x_min <= 0 && 0 <= x_max && y_min <= 0 && 0 <= y_max) then
              failwith "Rectangle must contain (0,0)"
            else
              (x_min, y_min, x_max, y_max)
        | _ -> failwith "Invalid arguments for -abs")
    | None -> (0, 0, 100, 100) 
  in
    if x_min <> 0 && y_min <> 0 && x_max <> 0 && y_max <> 0 then
      draw_rectangle { x_min = float_of_int x_min; x_max = float_of_int x_max; y_min = float_of_int y_min; y_max = float_of_int y_max };

  match List.find_opt (fun opt -> opt.name = "-cr") cmd.options with
  | Some _ -> draw_point 0 0 
  | None -> ();
;;