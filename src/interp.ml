open Geo

(* Code de la Section 4 du projet. *)

(*
type transformation =
  Translate of vector
| Rotate of point * angle
*)

type instruction =
  Move of transformation
| Repeat of int * program
| Either of program * program 
and program = instruction list

let is_deterministic (prog : program) : bool =
  let rec aux prog = 
    match prog with 
    | [] -> true
    | Move _ :: q -> aux q
    | Repeat (_, p) :: q -> aux p && aux q
    | Either (_, _) :: _ -> false
  in aux prog
;;

let unfold_repeat (prog : program) : program =
  
;;

let run_det (prog : program) (p : point) : point list =
  failwith "À compléter"

let target_reached_det (prog : program) (p : point) (target : rectangle) : bool =
  failwith "À compléter"

let run (prog : program) (p : point) : point list =
  failwith "À compléter"

let all_choices (prog : program) : program list =
  failwith "À compléter"

let target_reached (prog : program) (p : point) (r : rectangle) : bool =
  failwith "À compléter"