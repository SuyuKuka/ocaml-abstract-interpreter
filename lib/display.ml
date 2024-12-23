<<<<<<< HEAD:lib/display.ml
<<<<<<< HEAD:lib/display.ml
open Graphics;;
open Read;;
open Geo;;

type display = {
  width : int;
  height : int;
  scale : int;
}

let draw_axes (width : int) (height : int) (scale : int) : unit =
  let center_x = width / 2 in
  let center_y = height / 2 in

  moveto 0 center_y;
  lineto width center_y;
  moveto center_x 0;
  lineto center_x height;

  for x = 0 to width do
    if (x - center_x) mod scale = 0 then (
      moveto x (center_y - 5);
      lineto x (center_y + 5);
      moveto (x - 5) (center_y - 25);
      let value = float_of_int ((x - center_x) / scale) 
      in
      if x <> center_x then draw_string (string_of_float value)
    )
  done;

  for y = 0 to height do
    if (y - center_y) mod scale = 0 then (
      moveto (center_x - 5) y;
      lineto (center_x + 5) y;
      moveto (center_x - 25) y;
      let value = float_of_int ((y - center_y) / scale) 
      in
      if y <> center_y then draw_string (string_of_float value)
    )
  done;

  moveto (center_x + 10) (center_y - 10)
;;

let draw_point (x : int) (y : int) (scale : int) (cmd : command) : unit =
  let (r, g, b) = 
    match List.find_opt (fun opt -> opt.name = "-pc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -pc")
    | None -> (255, 0, 0)
  in set_color (rgb r g b);
  fill_circle (x / 2) (y / 2) (scale / 25);
;;

let draw_rectangle (rect : rectangle) (scale : int) (cmd : command) : unit =
  let (r, g, b) = 
    match List.find_opt (fun opt -> opt.name = "-rc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -rc")
    | None -> (255, 100, 100)
  in set_color (rgb r g b);
  draw_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min));

  fill_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min))
;;

let init_window (width : int) (height : int) (cmd : command) (window : bool) : unit =
  let () =
    if window then 
      clear_graph () 
    else 
      open_graph (" " ^ string_of_int width ^ "x" ^ string_of_int height);
  in set_window_title "Exécution pas à pas du programme";

  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-bc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -bc")
    | None -> (255, 255, 255)
  in let background_color = rgb r g b 
  in set_color background_color; 
  fill_rect 0 0 width height;

  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-fc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -fc")
    | None -> (0, 0, 0)
  in set_color (rgb r g b);
  draw_axes width height 100;
;;

let configure_display (cmd : command) (window : bool) : display =
  let display =
    match List.find_opt (fun opt -> opt.name = "-size") cmd.options with
    | Some size_option -> 
      (match size_option.arguments with
      | [w; h] -> { width = (int_of_string w); height = (int_of_string h); scale = 100 }
      | _ -> failwith "Invalid arguments for -size")
    | None -> { width = 1500; height = 900; scale = 100 }
  in init_window display.width display.height cmd window;
<<<<<<< HEAD:lib/display.ml

  if not window then
    if List.length cmd.options = 0 then
      draw_point display.width display.height display.scale cmd;

  let () =
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
            draw_rectangle { 
              x_min = float_of_int (x_min + display.width / 2); 
              x_max = float_of_int (x_max + display.width / 2); 
              y_min = float_of_int (y_min + display.height / 2); 
              y_max = float_of_int (y_max + display.height / 2); 
            } display.scale cmd;
        | _ -> failwith "Invalid arguments for -abs")
    | None -> ()
<<<<<<< HEAD:lib/display.ml
  in 
  let () = 
    match List.find_opt (fun opt -> opt.name = "-cr") cmd.options with
    | Some _ -> draw_point width height 100 cmd
    | None -> ().
;;

let close () = 
  print_endline "Programme terminé. Appuyez sur une touche du clavier pour fermer.";
  ignore (Graphics.read_key ());
  Graphics.close_graph ();
=======
  in
  let () = 
    match List.find_opt (fun opt -> opt.name = "-cr") cmd.options with
    | Some _ -> draw_point display.width display.height display.scale cmd 
    | None -> ()
  in (); 
=======
>>>>>>> 45901c6 (fix option, manque que l'exec rectangle):src/display.ml
  
  display;
>>>>>>> 090ed73 (affiche les points):src/display.ml
;;

let close () = 
  print_endline "Programme terminé. Appuyez sur une touche du clavier pour fermer.";
  ignore (Graphics.read_key ());
  Graphics.close_graph ();
=======
open Graphics;;
open Read;;
open Geo;;

type display = {
  width : int;
  height : int;
  scale : int;
}

let draw_axes (width : int) (height : int) (scale : int) : unit =
  let center_x = width / 2 in
  let center_y = height / 2 in

  moveto 0 center_y;
  lineto width center_y;
  moveto center_x 0;
  lineto center_x height;

  for x = 0 to width do
    if (x - center_x) mod scale = 0 then (
      moveto x (center_y - 5);
      lineto x (center_y + 5);
      moveto (x - 5) (center_y - 25);
      let value = float_of_int ((x - center_x) / scale) 
      in
      if x <> center_x then draw_string (string_of_float value)
    )
  done;

  for y = 0 to height do
    if (y - center_y) mod scale = 0 then (
      moveto (center_x - 5) y;
      lineto (center_x + 5) y;
      moveto (center_x - 25) y;
      let value = float_of_int ((y - center_y) / scale) 
      in
      if y <> center_y then draw_string (string_of_float value)
    )
  done;

  moveto (center_x + 10) (center_y - 10)
;;

let draw_point (x : int) (y : int) (scale : int) (cmd : command) : unit =
  let (r, g, b) = 
    match List.find_opt (fun opt -> opt.name = "-pc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -pc")
    | None -> (255, 0, 0)
  in set_color (rgb r g b);
  fill_circle (x / 2) (y / 2) (scale / 25);
;;

let draw_rectangle (rect : rectangle) (scale : int) (cmd : command) : unit =
  let (r, g, b) = 
    match List.find_opt (fun opt -> opt.name = "-rc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -rc")
    | None -> (255, 100, 100)
  in set_color (rgb r g b);
  draw_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min));

  fill_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min))
;;

let init_window (width : int) (height : int) (cmd : command) (window : bool) : unit =
  let () =
    if window then 
      clear_graph () 
    else 
      open_graph (" " ^ string_of_int width ^ "x" ^ string_of_int height);
  in set_window_title "Exécution pas à pas du programme";

  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-bc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -bc")
    | None -> (255, 255, 255)
  in let background_color = rgb r g b 
  in set_color background_color; 
  fill_rect 0 0 width height;

  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-fc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -fc")
    | None -> (0, 0, 0)
  in set_color (rgb r g b);
  draw_axes width height 100;
;;

let configure_display (cmd : command) (window : bool) : display =
  let display =
    match List.find_opt (fun opt -> opt.name = "-size") cmd.options with
    | Some size_option -> 
      (match size_option.arguments with
      | [w; h] -> { width = (int_of_string w); height = (int_of_string h); scale = 100 }
      | _ -> failwith "Invalid arguments for -size")
    | None -> { width = 1500; height = 900; scale = 100 }
  in init_window display.width display.height cmd window;
  
  display;
;;

let close () = 
  print_endline "Programme terminé. Appuyez sur une touche du clavier pour fermer.";
  ignore (Graphics.read_key ());
  Graphics.close_graph ();
>>>>>>> 62e73c5 (Modifications dans fichier1.txt):src/display.ml
=======
open Graphics;;
open Read;;
open Geo;;

type display = {
  width : int;
  height : int;
  scale : int;
}

let draw_axes (width : int) (height : int) (scale : int) : unit =
  let center_x = width / 2 in
  let center_y = height / 2 in

  moveto 0 center_y;
  lineto width center_y;
  moveto center_x 0;
  lineto center_x height;

  for x = 0 to width do
    if (x - center_x) mod scale = 0 then (
      moveto x (center_y - 5);
      lineto x (center_y + 5);
      moveto (x - 5) (center_y - 25);
      let value = float_of_int ((x - center_x) / scale) 
      in
      if x <> center_x then draw_string (string_of_float value)
    )
  done;

  for y = 0 to height do
    if (y - center_y) mod scale = 0 then (
      moveto (center_x - 5) y;
      lineto (center_x + 5) y;
      moveto (center_x - 25) y;
      let value = float_of_int ((y - center_y) / scale) 
      in
      if y <> center_y then draw_string (string_of_float value)
    )
  done;

  moveto (center_x + 10) (center_y - 10)
;;

let draw_point (x : int) (y : int) (scale : int) (cmd : command) : unit =
  let (r, g, b) = 
    match List.find_opt (fun opt -> opt.name = "-pc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -pc")
    | None -> (255, 0, 0)
  in set_color (rgb r g b);
  fill_circle (x / 2) (y / 2) (scale / 25);
;;

let draw_rectangle (rect : rectangle) (scale : int) (cmd : command) : unit =
  let (r, g, b) = 
    match List.find_opt (fun opt -> opt.name = "-rc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -rc")
    | None -> (255, 100, 100)
  in set_color (rgb r g b);
  draw_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min));

  fill_rect
    (int_of_float rect.x_min)
    (int_of_float rect.y_min)
    (int_of_float (rect.x_max -. rect.x_min))
    (int_of_float (rect.y_max -. rect.y_min))
;;

let init_window (width : int) (height : int) (cmd : command) (window : bool) : unit =
  let () =
    if window then 
      clear_graph () 
    else 
      open_graph (" " ^ string_of_int width ^ "x" ^ string_of_int height);
  in set_window_title "Exécution pas à pas du programme";

  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-bc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -bc")
    | None -> (255, 255, 255)
  in let background_color = rgb r g b 
  in set_color background_color; 
  fill_rect 0 0 width height;

  let (r, g, b) = match List.find_opt (fun opt -> opt.name = "-fc") cmd.options with
    | Some color_option -> 
      (match color_option.arguments with
      | [r; g; b] -> (int_of_string r, int_of_string g, int_of_string b)
      | _ -> failwith "Invalid arguments for -fc")
    | None -> (0, 0, 0)
  in set_color (rgb r g b);
  draw_axes width height 100;
;;

let configure_display (cmd : command) (window : bool) : display =
  let display =
    match List.find_opt (fun opt -> opt.name = "-size") cmd.options with
    | Some size_option -> 
      (match size_option.arguments with
      | [w; h] -> { width = (int_of_string w); height = (int_of_string h); scale = 100 }
      | _ -> failwith "Invalid arguments for -size")
    | None -> { width = 1500; height = 900; scale = 100 }
  in init_window display.width display.height cmd window;
  
  display;
;;

let close () = 
  print_endline "Programme terminé. Appuyez sur une touche du clavier pour fermer.";
  ignore (Graphics.read_key ());
  Graphics.close_graph ();
>>>>>>> d2565a8253cf41a78a0a3095b981e0df89e3652c:src/display.ml
;;