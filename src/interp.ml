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
  Parcours la liste si on trouve un Either retourne false,
  sinon déroule la liste jusqu'a la fin et renvoie true.
*)
let is_deterministic (prog : program) : bool =
  let rec aux prog = 
    match prog with 
    | [] -> true
    | Move _ :: q -> aux q
    | Repeat (_, p) :: q -> aux p && aux q
    | Either (_, _) :: _ -> false
  in aux prog
;;

(*  unfold_repeat : program -> program
  Parcours la liste pour déterminer si on a un Repeat,
  si on en trouve un on crée une liste d'instruction de Move pour supprimer le Repeat,
  puis on l'a concatene avec le reste de la liste. *)
let unfold_repeat (prog : program) : program = 
  let rec unfold i prog list =
    if i <= 0 then list
    else unfold (i - 1) prog (list @ prog)
  in
  let rec aux prog = 
    match prog with 
    | [] -> prog
    | Move t :: q -> Move t :: aux q
    | Repeat (i, p) :: q -> unfold i p [] @ aux q
    | Either (_, _) :: _ -> failwith "Programme non déterministe"
  in aux prog
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