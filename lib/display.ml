open Graphics;;
open Read;;

let draw_axes (r : int) (g : int) (b : int) (width : int) (height : int) : unit =
  let center_x = width / 2 in
  let center_y = height / 2 in
  set_color black;

  moveto 0 center_y;
  lineto width center_y;

  moveto center_x 0;
  lineto center_x height;

  for x = 0 to width do
    if x mod 50 = 0 then (
      moveto x (center_y - 5);
      lineto x (center_y + 5);

      moveto x (center_y - 20);
      draw_string (string_of_int (x - center_x))
    )
  done;

  for y = 0 to height do
    if y mod 50 = 0 then (
      moveto (center_x - 5) y;
      lineto (center_x + 5) y;

      moveto (center_x - 30) y;
      draw_string (string_of_int (center_y - y))
    )
  done;

  moveto (center_x + 10) (center_y - 10);
  draw_string "(0, 0)";
;;

let draw_point (x : int) (y : int) : unit =
  set_color red;
  fill_circle x y 5
;;

let draw_rectangle (x_min : int) (y_min : int) (x_max : int) (y_max : int) : unit =
  set_color blue;
  draw_rect x_min y_min (x_max - x_min) (y_max - y_min) 
;;

let set_background_color (color : color) (width : int) (height : int) : unit = 
  set_color color;
  fill_rect 0 0 width height;
;;

let init_window (width : int) (height : int) (cmd : command) : unit =
  open_graph (" " ^ string_of_int width ^ "x" ^ string_of_int height);
  set_window_title "Exececution pas a pas du programme";
  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-bc") cmd.options with
    | Some color_option ->
        (match color_option.arguments with
        | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
        | _ -> failwith "Invalid arguments")
    | None -> (0, 0, 0)
  in let tmp = rgb r g b
  in set_background_color tmp width height;
  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-fc") cmd.options with
    | Some color_option ->
        (match color_option.arguments with
         | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
         | _ -> failwith "Invalid arguments")
    | None -> (255, 255, 255)
  in foreground r g b;
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
  in init_window width height cmd;
;;