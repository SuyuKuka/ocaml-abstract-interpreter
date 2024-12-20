type option = {
  name : string;
  arguments : string list;
}

type command = {
  cmd : string;
  options : option list;
  program : string;
}

let is_digit_only (s : string) : bool =  
  String.for_all (fun c -> 
    let code = Char.code c 
    in code >= 48 && code <= 57 
  ) s
;;

let remove (n : int) (list : string list) : string list = 
  let rec aux n list = 
    if n <= 0 then 
      list 
    else 
      match list with 
      | [] -> [] 
      | _ :: t -> aux (n - 1) t 
  in aux n list 
;;

let take (n : int) (list : string list) : string list =
  let rec aux n list acc =
    if n <= 0 then 
      List.rev acc
    else 
      match list with
      | [] -> failwith "Not enough elements to take"
      | x :: t -> aux (n - 1) t (x :: acc)
  in aux n list []
;;

let extract_opt (n : int) (options : string list) : string list * string list = 
  if List.length options < n then 
    failwith "Not enough arguments"
  else 
    let opt = take n options in
    let reset = remove n options in
    (opt, reset)
;;

let rec parse_options options : option list =
  match options with
  | [] -> []
  | opt :: rest -> 
    let (args, remaining) =
      match opt with
      | "-abs" -> extract_opt 4 rest
      | "-cr" -> extract_opt 0 rest
      | "-bc" -> extract_opt 3 rest
      | "-fc" -> extract_opt 3 rest
      | "-rc" -> extract_opt 3 rest
      | "-pc" -> extract_opt 3 rest
      | "-size" -> extract_opt 2 rest
      | _ -> failwith (opt ^ ": option not found")
    in { name = opt; arguments = args } :: parse_options remaining
;;

let parse_command (args : string list) : command =
  match args with
  | [] -> failwith "empty command"
  | cmd :: rest ->
      if cmd <> "interp" then
        failwith (cmd ^ ": command not found")
      else
        let rev_args = List.rev rest 
        in let program =
          match rev_args with
          | [] -> failwith "syntax error"
          | x :: _ ->
              if x = "1" || x = "2" || x = "3" then 
                x
              else 
                failwith "program not found"
        in let options = List.rev (List.tl rev_args) 
        in { cmd; options = parse_options options; program }
;;

let read_cmd () : command =
  print_endline "interp [OPTIONS] [PROG] :";
  let input = read_line () in
  let args = String.split_on_char ' ' input in
  let command = parse_command args in
  (* Affichage des résultats pour debug ou vérification *)
  Printf.printf "Command : %s\n" command.cmd;
  List.iter (fun opt ->
    Printf.printf "Option : %s\n" opt.name;
    Printf.printf "Arguments : %s\n" (String.concat ", " opt.arguments)
  ) command.options;
  Printf.printf "Program : %s\n" command.program;
  command
  ;;