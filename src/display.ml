open Graphics;;

let init_window width height =
  open_graph (" " ^ string_of_int width ^ "x" ^ string_of_int height);
  set_color black;
  ignore (read_key ());
  close_graph ()
;;

let draw_point x y =
  set_color red;
  fill_circle x y 5

let draw_rectangle x_min y_min x_max y_max =
  set_color blue;
  draw_rect x_min y_min (x_max - x_min) (y_max - y_min) 
