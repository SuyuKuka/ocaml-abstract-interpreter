open Geo
open Interp

(* Code de la Section 5 du projet. *)

(** [sample : rectangle -> point]
  * Renvoie un point au hasard dans le rectangle r.
  *)
let sample (rect : rectangle) : point =
  { x = rect.x_min +. Random.float (rect.x_max -. rect.x_min);
    y = rect.y_min +. Random.float (rect.y_max -. rect.y_min) }
;;

(** [transform_rect : transformation -> rectangle -> rectangle]
  * Renvoie le rectangle r transformé par la transformation t.
  *)  
let transform_rect (t : transformation) (r : rectangle) : rectangle =
  match t with 
  | Translate vect -> 
    let translation_min = (translate vect { x = r.x_min; y = r.y_min })
    in let translation_max = (translate vect { x = r.x_max; y = r.y_max })
    in { x_min = translation_min.x; x_max = translation_max.x;
      y_min = translation_min.y; y_max = translation_max.y }
  | Rotate (c, alpha) -> 
    let points = corners r 
    in let rotate_points = List.map (rotate c alpha) points 
    in rectangle_of_list rotate_points
;;


(** [run_rect : program -> rectangle -> rectangle list]
  * Renvoie la liste des rectangles visités par le robot.
  *)
let run_rect (prog : program) (r : rectangle) : rectangle list =
  let rec aux (prog : program) (r : rectangle) : rectangle list =
    match prog with 
    | [] -> [r]
    | Move t :: q -> 
      let rect = transform_rect t r 
      in rect :: aux q r
    | Repeat (n, prog) :: q -> 
      let rec repeat (n : int) (prog : program) (r : rectangle) (acc : rectangle list) : rectangle list =
        if n <= 0 then acc
        else
          let transformation = aux prog r 
          in let accumulate = List.fold_left (fun acc r -> if List.mem r acc then acc else r :: acc) acc transformation
          in repeat (n - 1) prog (List.hd transformation) accumulate      
      in repeat n prog r [r]
    | Either (p1, p2) :: q -> 
      let r1 = aux p1 r 
      in let r2 = aux p2 r 
      in r1 @ r2 @ aux q r
  in List.rev (aux prog r)
;;

(** [inclusion : rectangle -> rectangle -> bool]
  * Renvoie true si r est inclus dans t, false sinon.
  *)
let inclusion (r : rectangle) (t : rectangle) : bool =
  t.x_min <= r.x_min && r.x_max <= t.x_max
  && t.y_min <= r.y_min && r.y_max <= t.y_max
;;

(** [target_reached_rect : program -> rectangle -> rectangle -> bool]
  * Renvoie true si le rectangle r est inclus dans le rectangle target, false sinon.
  *)
let target_reached_rect (prog : program) (r : rectangle) (target : rectangle) : bool =
  
;;

let run_polymorphe (transform : transformation -> 'a -> 'a) (prog : program) (i : 'a) : 'a list =
  failwith "À compléter"

let rec over_approximate (prog : program) (r : rectangle) : rectangle =
  failwith "À compléter"

let feasible_target_reached (prog : program) (r : rectangle) (target : rectangle) : bool =
  failwith "À compléter"
