
(* Code de la Section 3 du projet. *)

type coord2D = {
    x : float;
    y : float
  }
type point = coord2D
type vector = coord2D
type angle = float

(* 3.0 | translate : vector -> point -> point
* Calcule la translation du point p selon le vecteur v.
*)
let translate (v : vector) (p : point) : point =
  { x = p.x +. v.x; y = p.y +. v.y }
  ;;

(* 3.1 | rad_of_deg : angle -> angle
* Conversion radians -> degrés
*)
let rad_of_deg (a : angle) : angle =
  a *. Float.pi /. 180.
;;

(* 3.1 | deg_of_rad : angle -> angle
* Conversion degrés -> radians
*)
let deg_of_rad (a : angle) : angle =
  a *. 180. /. Float.pi
;;

(* 3.2 | rotate : point -> angle -> point -> point
* Renvoie le point obtenu par la rotation du point p
* d'angle alpha (en degrés) autour du centre c selon la formule.
*)
let rotate (c : point) (alpha : angle) (p : point) : point =
  let theta = rad_of_deg alpha in
  { 
    x = c.x +. (p.x -. c.x) *. Float.cos theta -. (p.y -. c.y) *. Float.sin theta;
    y = c.y +. (p.x -. c.x) *. Float.sin theta +. (p.y -. c.y) *. Float.cos theta
  }
;; (* petite imprécision de 3 à la fin, grave ou non ? *)
  
type transformation =
  Translate of vector
| Rotate of point * angle

(* 3.3 | transform : transformation -> point -> point
* Applique la transformation t au point p.
* t est soit translate (3.0), soit rotate (3.2).
*)
let transform (t : transformation) (p : point) : point =
  match t with
  | Translate vect -> translate vect p
  | Rotate (c, alpha) -> rotate c alpha p
;; (* Ajout vérif si t aucun des deux ? *)

type rectangle = {
    x_min : float;
    x_max : float;
    y_min : float;
    y_max : float
  }

(* 3.4 | in_rectangle -> rectangle -> point -> bool
* Détermine si le point p est à l'intérieur du rectangle r.
* (La vérification est effectuée au sens large, bords inclus.)
*)
let in_rectangle (r : rectangle) (p : point) : bool =
  r.x_min <= p.x && p.x <= r.x_max &&
  r.y_min <= p.y && p.y <= r.y_max
;;

(* 3.5 | corners : rectangle -> point list
* Renvoie la liste des sommets du rectangle r.
*)
let corners (r :rectangle) : point list =
  [ {x=r.x_min; y=r.y_max}; {x=r.x_max; y=r.y_max}; {x=r.x_max; y=r.y_min}; {x=r.x_min; y=r.y_min} ]
;; (* Nommer les points [a,b,c,d] ? *)

(* 3.6 | rectangle_of_list : point list -> rectangle
* Renvoie le plus petit rectangle contenant tous les points de la liste,
* soit le plus grand rectangle possible avec les points de pl.
* -> Si pl est vide, erreur.
* -> Sinon, on utilise List.fold.left afin de calculer
*    les valeurs min et max possibles de x et y dans la liste.
* Dans pl, avec "fun(xmin, xmax, ymin, ymax) p" on:
*  - Compare xmin/p.x et ymin/p.y, garde le plus petit.
*  - Compare xmax/p.x et ymax/p.y, garde le plus grand.
*)
let rectangle_of_list (pl : point list) : rectangle = 
  (* Si pl vide *)
  if pl = [] then failwith "Erreur : liste de points vide.";
  match pl with
  | [p] -> {x_min = p.x; x_max = p.x; y_min = p.y; y_max = p.y} (* Si pl que 1 point | cas useless ? *)
  | _ -> (* Sinon, cas classique *)
      let first = List.hd pl in (* Init les val de base à partir du 1er point de pl *)
      let (x_min, x_max, y_min, y_max) =
        List.fold_left (fun (xmin, xmax, ymin, ymax) p ->
            (Float.min xmin p.x, Float.max xmax p.x, Float.min ymin p.y, Float.max ymax p.y)
          ) (first.x, first.x, first.y, first.y) pl
      in
      { x_min = x_min; x_max = x_max; y_min = y_min; y_max = y_max } (* Construction du rectangle *)
;;
