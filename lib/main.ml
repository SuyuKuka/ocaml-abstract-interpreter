open Graphics;;
open Read;;
(* let main () =
  Read.read_cmd ()
  (* open_graph " 600x400";
  set_color blue;
  plot 300 200;
  ignore (read_key ());
  close_graph () *)
;; *)
let main () =
  let command = Read.read_cmd () in
  Printf.printf "%s Command success.\n" command.cmd
;;