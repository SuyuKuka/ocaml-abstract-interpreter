(* Définition du type pour représenter une option avec ses arguments *)
type option = {
  name : string;        (* Nom de l'option, par ex. "-abs" *)
  arguments : string list;  (* Liste des arguments associés à l'option *)
}

(* Définition du type pour représenter une commande complète *)
type command = {
  cmd : string;         (* Nom de la commande principale, par ex. "interp" *)
  options : option list;  (* Liste des options analysées *)
  program : string;     (* Programme spécifié, par ex. "1", "2", ou "3" *)
}

(* Vérifie si une chaîne est composée uniquement de chiffres *)
val is_digit_only : string -> bool

(* Supprime les n premiers éléments d'une liste *)
val remove : int -> string list -> string list

(* Prend les n premiers éléments d'une liste *)
val take : int -> string list -> string list

(* Extrait les n premiers éléments d'une liste et retourne 
   ces éléments ainsi que le reste de la liste *)
val extract_opt : int -> string list -> string list * string list

(* Analyse une liste d'options et retourne une liste d'options structurées *)
val parse_options : string list -> option list

(* Analyse une commande en chaîne de caractères pour produire une structure command *)
val parse_command : string list -> command

(* Lit une commande depuis l'entrée standard et affiche ses composants *)
val read_cmd : unit -> unit
