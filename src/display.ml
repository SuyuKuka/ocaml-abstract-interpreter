open Graphics;;
open Read;;
open Geo;;

let draw_axes (width : float) (height : float) (scale : int) : unit =
  let center_x = int_of_float (width /. 2.) 
  in let center_y = int_of_float (height /. 2.) 
  in set_color black;

  moveto 0 center_y;
  lineto (int_of_float width) center_y;

  moveto center_x 0;
  lineto center_x (int_of_float height);

  for x = 0 to int_of_float width do
    if x mod (scale) = 0 then (
      moveto x (center_y - 5);
      lineto x (center_y + 5);

      moveto x (center_y - 20);
      draw_string (string_of_float ((float_of_int x -. width /. 2.) /. float_of_int scale))
    )
  done;

  for y = 0 to int_of_float height do
    if y mod (scale) = 0 then (
      moveto (center_x - 5) y;
      lineto (center_x + 5) y; 

      moveto (center_x - 30) y;
      draw_string (string_of_float ((float_of_int y -. height /. 2.) /. float_of_int scale))
    )
  done;

  moveto (center_x + 10) (center_y - 10);
;;

let draw_point (x : int) (y : int) : unit =
  set_color red;
  fill_circle x y 5
;;

let draw_rectangle (rect : rectangle) : unit =
  set_color blue;
  draw_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min))
;;

let init_window (width : float) (height : float) (cmd : command) : unit =
  open_graph (" " ^ string_of_float width ^ "x" ^ string_of_float height);
  set_window_title "Exececution pas a pas du programme";
  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-bc") cmd.options with
    | Some color_option ->
        (match color_option.arguments with
        | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
        | _ -> failwith "Invalid arguments")
    | None -> (255, 255, 255)
  in let background_color = rgb r g b in
  set_color background_color; 
  fill_rect 0 0 (int_of_float width) (int_of_float height);

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
         | _ -> failwith "Invalid arguments")
    | None -> (600, 400)
  in init_window (float_of_int width) (float_of_int height) cmd;
;;