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
  * On utilise translate et rotate pour faire la translation et la rotation 
  * du rectangle et renvoie le rectangle transformé.
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
  * Si on a un Move, on ajoute le rectangle r transformé par la transformation t.
  * Si on a un Repeat, on répete le prog program contenu dans le Repeat et on l'ajoute a la fin de la liste.
  * Si on a un Either, on prends les deux prog et on l'ajoute a la fin de la liste.
  *)
let run_rect (prog : program) (r : rectangle) : rectangle list =
  let rec aux (prog : program) (r : rectangle) : rectangle list =
    match prog with 
    | [] -> [r]
    | Move t :: q -> 
      let rect = transform_rect t r 
      in r :: aux q rect
    | Repeat (n, prog') :: q ->
        let rec n_repeat_prog n (prog : program) : program =
          if n != 0 then prog @ n_repeat_prog (n - 1) (prog)
          else []
        in let repeat = n_repeat_prog n prog' @ q
        in aux repeat r
    | Either (p1, p2) :: q -> 
      let r1 = aux p1 r 
      in let r2 = aux p2 r 
      in r :: (r1 @ r2 @ aux q r) 
  in aux prog r 
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
  * On utilise all_choices pour avoir tous les choix de prog et on parcours la liste.
  * On regarde si le rectangle est inclus dans target si non on renvoie false.
  * Quand on arrive au bout de la liste on renvoie true car le rectangle est inclus dans target.
  *)
let target_reached_rect (prog : program) (r : rectangle) (target : rectangle) : bool =
    let rec aux (prog : program list) (r : rectangle) (target : rectangle) : bool = 
      match prog with
      | [] -> true
      | prog :: program ->
        if inclusion (List.hd (List.rev (run_rect prog r))) target then aux program r target
        else false
    in aux (all_choices prog) r target
;;

let run_polymorphe (transform : transformation -> 'a -> 'a) (prog : program) (i : 'a) : 'a list =
  let rec aux (prog : program) (state : 'a) (states : 'a list) : 'a list =
    match prog with
    | [] -> states (* Cas de base :  programme vide, return les états accumulés *)
    | Move t :: q -> (* Cas Move : applique transformation t à l'état courant *)
        let new_state = f t state in
        aux q new_state (new_state :: states)
    | Repeat (n, prog') :: q ->
        let unfolded_prog = (* On déroule les repeats n fois *) 
          let rec n_repeat_prog n (prog : program) =
            if n = 0 then []
            else prog @ n_repeat_prog (n - 1) prog
          in n_repeat_prog n prog'
        in aux (unfolded_prog @ q) state states (* exécute le programme déroulé suivi du reste du programme *)
    | Either (p1, p2) :: q -> (* Cas Either : on choisit random entre deux sous-programmes *)
        if Random.bool () 
        then aux (p1 @ q) state states
        else aux (p2 @ q) state states
  in List.rev (aux prog init [init]) (* Inverse la liste pour return les états dans le bon ordre *)
;;

let rec over_approximate (prog : program) (r : rectangle) : rectangle =
  let rec aux (prog : program) (r : rectangle) : rectangle =
    match prog with
    | [] -> r (* Si programme vide, on return le rectangle inchangé *)
    | Move t :: q -> 
        let new_r = transform_rect t r in (* Applique la transform_rect au rectangle actuel et continuer avec le reste *)
        aux q new_r
    | Repeat (n, prog') :: q ->
        let rec repeat_rect n r =
          if n = 0 then r
          else (* Calcul du rectangle après une itération du sous-programme *)
            let next_r = aux prog' r in (* Fusion avec le rectangle initial *)
            {
              x_min = Float.min r.x_min next_r.x_min;
              x_max = Float.max r.x_max next_r.x_max;
              y_min = Float.min r.y_min next_r.y_min;
              y_max = Float.max r.y_max next_r.y_max;
            }
            |> repeat_rect (n - 1)
        in
        aux q (repeat_rect n r) (* Applique les répétitions, puis continuer avec le reste du programme *)
    | Either (p1, p2) :: q -> (* Calcule les rectangles atteints par les 2 branches *)
        let r1 = aux p1 r in
        let r2 = aux p2 r in
        let combined_r = { (* Calcule le + petit rectangle contenant les deux *)
          x_min = Float.min r1.x_min r2.x_min;
          x_max = Float.max r1.x_max r2.x_max;
          y_min = Float.min r1.y_min r2.y_min;
          y_max = Float.max r1.y_max r2.y_max;
        } in aux q combined_r
  in aux prog r
;;

let feasible_target_reached (prog : program) (r : rectangle) (target : rectangle) : bool =
  failwith "À compléter"
