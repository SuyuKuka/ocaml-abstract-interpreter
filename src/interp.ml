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

(* is_deterministic : program -> bool 
 * Parcours la liste si on trouve un Either retourne false,
 * sinon déroule la liste jusqu'a la fin et renvoie true.
 *)
let is_deterministic (prog : program) : bool =
  let rec aux (prog : program) : bool = 
    match prog with 
    | [] -> true
    | Move _ :: q -> aux q
    | Repeat (_, p) :: q -> aux p && aux q
    | Either (_, _) :: _ -> false
  in aux prog
;;

(* unfold_repeat : program -> program
 * Parcours la liste pour déterminer si on a un Repeat,
 * si on en trouve un on crée une liste d'instruction de Move pour supprimer le Repeat,
 * puis on l'a concatene avec le reste de la liste.
 * Si on a un Either, pour la premiere partie du projet on leve une exception avec failwith
 * Sinon on ajoute le Either dans la liste
 *)
let unfold_repeat (prog : program) : program = 
  let rec unfold (i : int) (prog : program) (list : instruction list) : instruction list =
    if i <= 0 then list
    else unfold (i - 1) prog (list @ prog)
  in
  let rec aux (prog : program) : program = 
    match prog with 
    | [] -> prog
    | Move t :: q -> Move t :: aux q
    | Repeat (i, p) :: q -> unfold i p [] @ aux q
    | Either (p1, p2) :: q -> Either (p1, p2) :: aux q
  in aux prog
;;

(* run_det : program -> point -> point list
 * On unfold_repeat le programme au début pour éviter d'avoir des Repeat,
 * ensuite on parcours la liste d'instruction.
 * On utilise la fonction transform de Geo qui permet de faire
 * la translation, et on mets le nouveau point dans la liste et on met a jour 
 * ma position courante par le nouveau, et a la fin on reverse la liste de point.
 *)
let run_det (prog : program) (p : point) : point list =
  let rec aux (prog : program) (p : point) (l : point list) : point list = 
    match prog with
    | [] -> l
    | Move t :: q -> aux q (transform t p) (transform t p :: l)
    | Repeat (_, _) :: _ -> failwith "Erreur : unfold_repeat"
    | Either (_, _) :: _ -> failwith "Erreur : Programme non déterministe"
  in List.rev (aux (unfold_repeat prog) p [p])
;;
  
(* target_reached_det : program -> point -> rectangle -> bool
 * On utilise run_det pour avoir la liste des points visités du robot,
 * On va prendre le dernier point visité et on regarde si ce point est dans le rectangle,
 * si oui renvoie true, sinon false.
 *)
let target_reached_det (prog : program) (p : point) (target : rectangle) : bool = 
  in_rectangle target (List.hd (List.rev (run_det prog p)))
;;
  
(* run : program -> point -> point list
 * On unfold_repeat pour supprimer tous les repeat du program,
 * puis on parcours le program, si on trouve un move, on utilise transform
 * qui fera la translation ou ratation. Si on a un repeat, c'est une erreur
 * car on était censé supprimer tous les repeat avec le unfold_repeat.
 * Si on a un Either, on utilise Random.bool() pour choisir dans quelle
 * branche executer.
 *)
let run (prog : program) (p : point) : point list =
  let rec aux (prog : program) (p : point) (l : point list) : point list = 
    match prog with
    | [] -> l
    | Move t :: q -> aux q (transform t p) (transform t p :: l)
    | Repeat (_, _) :: _ -> failwith "Erreur : unfold_repeat"
    | Either (p1, p2) :: q -> 
      if (Random.bool()) then aux p1 p l
      else aux p2 p l
  in List.rev (aux (unfold_repeat prog) p [p])
;;

(* all_choices : program -> program list
 * On unfold_repeat le programme au début pour éviter d'avoir des Repeat,
 * ensuite on parcours la liste d'instruction.
 * On met tous les choix possibles dans une liste et on les fusionne.
*)
let rec all_choices (prog : program) : program list =
  let rec aux (prog : program) : program list =
    match prog with
    | [] -> [[]] 
    | instruc :: p' ->
      match instruc with
      | Move (transformation) -> List.map (fun rest -> instruc :: rest) (aux p')
      | Repeat (_, _) -> failwith "Erreur : unfold_repeat"
      | Either (p1, p2) ->
        let choices_p1 = aux (p1 @ p') in
        let choices_p2 = aux (p2 @ p') in
        choices_p1 @ choices_p2
  in List.rev (aux (unfold_repeat prog))
;;

(* target_reached : program -> point -> rectangle -> bool
 * On utilise run pour avoir la liste des points visités du robot,
 * On va prendre le dernier point visité et on regarde si ce point est dans le rectangle,
 * si oui renvoie true, sinon false.
*)
let target_reached (prog : program) (p : point) (r : rectangle) : bool =
  if not (in_rectangle r p) && prog == [] then false
  else
    let rec aux (l : program list) : bool = 
      match l with
      | [] -> true
      | h :: q ->
        if not (in_rectangle r (List.hd (List.rev (run h p)))) then false
        else aux q
    in aux (all_choices prog)
;;