open Geo;;
open Interp;;
open Display;;
open Graphics;;
open Approx;;

type state = {
  position : point;
  program : program;
  reset : program;
}

type state_rect = {
  rect : rectangle;
  program : program;
  reset : program;
}

let init_state (prog : program) (p : point) : state =  {
  position = p;
  program = prog;
  reset = prog;
}

let init_state_rect (prog : program) (r : rectangle) : state_rect = {
  rect = r;
  program = prog;
  reset = prog;
}

let execute_step (state : state) : state option =
  match state.program with
  | [] -> None
  | instr :: rest ->
<<<<<<< HEAD:lib/exec.ml
      let new_position, new_program = match instr with
<<<<<<< HEAD:lib/exec.ml
<<<<<<< HEAD:lib/exec.ml
        | Move transform -> Geo.transform transform state.position, rest (* Cas Move: juste transform la position *)
<<<<<<< HEAD:lib/exec.ml
<<<<<<< HEAD:lib/exec.ml
        | Repeat (n, sub_prog) ->  (* Cas Repeat: on répète n fois le programme avant de return la position de fin ? *)
          if n > 1 then
            state.position, [Repeat (n - 1, sub_prog)] @ rest
=======
        | Interp.Move transform -> Geo.transform transform state.position, rest (* Cas Move: juste transform la position *)
        | Interp.Repeat (n, sub_prog) ->  (* Cas Repeat: on répète n fois le programme avant de return la position de fin ? *)
          if n > 1 then
            state.position, [Interp.Repeat (n - 1, sub_prog)] @ rest
>>>>>>> 181c66a (Logique exécution des programmes (pb de repeat résolu), reste affichage):src/exec.ml
=======
        | Move transform -> Geo.transform transform state.position, rest (* Cas Move: juste transform la position *)
        | Repeat (n, sub_prog) ->  (* Cas Repeat: on répète n fois le programme avant de return la position de fin ? *)
          if n > 1 then
            state.position, [Repeat (n - 1, sub_prog)] @ rest
>>>>>>> dfe4a0c (des ptits trucs):src/exec.ml
          else
            state.position, rest
        | Either (choice1, choice2) -> (* Cas Either: choix 1 mis par défaut, implémenter random après ? *)
          state.position, choice1 @ rest
=======
        | Repeat (n, sub_prog) when n > 1 -> ( (* Cas Repeat: à fix pour qu'il reconnaisse le cas où c'est Either | print_endline "Repeat reconnu"; *)
            match sub_prog with
            | [] -> state.position, rest (* Sous-programme vide, on saute *)
            | first_instr :: remaining_sub_prog -> (* Exécute direct la 1ère instruction du sous-programme *)
                let intermediate_position = 
                  match first_instr with
                  | Move transform -> Geo.transform transform state.position
                  | _ -> state.position
                in (* Réinsère les instructions restantes du Repeat *)
                intermediate_position, remaining_sub_prog @ [Repeat (n - 1, sub_prog)] @ rest
          )
        | Repeat (_, sub_prog) -> ( (* Dernière itération : exécute uniquement le sous-programme restant *)
            match sub_prog with
            | [] -> state.position, rest
            | first_instr :: remaining_sub_prog ->
                let intermediate_position =
                  match first_instr with
                  | Move transform -> Geo.transform transform state.position
                  | _ -> state.position
                in
                intermediate_position, remaining_sub_prog @ rest
          )
        | Either (choice1, choice2) -> 
          if Random.bool () then 
            state.position, choice1 @ rest 
          else 
            state.position, choice2 @ rest
>>>>>>> cd48240 (Fix Repeat solo; à fix Either dans Repeat):src/exec.ml
=======
        | Repeat (n, sub_prog) when n > 1 -> (* Cas Repeat: gère les n répétitions et sous-cas des itérations *)
          (match sub_prog with
          | [] -> state.position, rest (* Sous-programme vide, on saute *)
          | first_instr :: remaining_sub_prog -> (* Évalue explicitement la première instruction du sous-programme *)
              let intermediate_position, updated_sub_prog = 
                match first_instr with
                | Move transform -> 
                    Geo.transform transform state.position, remaining_sub_prog
                | Either (choice1, choice2) -> 
                    let selected_choice = if Random.bool () then choice1 else choice2 in
                    (match selected_choice with
                    | [] -> state.position, remaining_sub_prog
                    | choice_first :: choice_rest ->
                        (match choice_first with
                        | Move transform -> Geo.transform transform state.position, choice_rest @ remaining_sub_prog
                        | _ -> state.position, remaining_sub_prog))
                | _ -> state.position, remaining_sub_prog
              in (* Réinsérer la répétition avec n - 1 itérations restantes *)
              intermediate_position, updated_sub_prog @ [Repeat (n - 1, sub_prog)] @ rest)
=======
    let new_position, new_program = match instr with
      | Move transform -> Geo.transform transform state.position, rest (* Cas Move: juste transform la position *)
      | Repeat (n, sub_prog) when n > 1 -> (* Cas Repeat: gère les n répétitions et sous-cas des itérations *)
        (match sub_prog with
        | [] -> state.position, rest (* Sous-programme vide, on saute *)
        | first_instr :: remaining_sub_prog -> (* Évalue explicitement la première instruction du sous-programme *)
          let intermediate_position, updated_sub_prog = 
            match first_instr with
            | Move transform -> Geo.transform transform state.position, remaining_sub_prog
            | Either (choice1, choice2) -> 
              let selected_choice = if Random.bool () then choice1 else choice2 
              in
              (match selected_choice with
              | [] -> state.position, remaining_sub_prog
              | choice_first :: choice_rest ->
                (match choice_first with
                | Move transform -> Geo.transform transform state.position, choice_rest @ remaining_sub_prog
                | _ -> state.position, remaining_sub_prog))
              | _ -> state.position, remaining_sub_prog
              in intermediate_position, updated_sub_prog @ [Repeat (n - 1, sub_prog)] @ rest)
>>>>>>> ae0d4f2 (rect fonctionnel):src/exec.ml

      | Repeat (_, sub_prog) -> (* Dernière itération : exécuter uniquement le sous-programme restant *)
          (match sub_prog with
          | [] -> state.position, rest
          | first_instr :: remaining_sub_prog -> 
            let intermediate_position, updated_sub_prog = 
              match first_instr with
              | Move transform -> Geo.transform transform state.position, remaining_sub_prog
              | Either (choice1, choice2) -> 
                  let selected_choice = 
                    if Random.bool () then 
                      choice1 
                    else 
                      choice2 
                  in
                  (match selected_choice with
                  | [] -> state.position, remaining_sub_prog
                  | choice_first :: choice_rest ->
                      (match choice_first with
                      | Move transform -> Geo.transform transform state.position, choice_rest @ remaining_sub_prog
                      | _ -> state.position, remaining_sub_prog))
              | _ -> state.position, remaining_sub_prog
            in intermediate_position, updated_sub_prog @ rest)
            
      | Either (choice1, choice2) -> 
          let selected_choice = 
            if Random.bool () then 
              choice1 
            else 
              choice2 
            in
            (match selected_choice with
<<<<<<< HEAD:lib/exec.ml
              | [] -> state.position, rest
              | first_instr :: remaining_choice -> 
                (match first_instr with
                  | Move transform -> Geo.transform transform state.position, remaining_choice @ rest
                  | _ -> state.position, remaining_choice @ rest))
>>>>>>> 8aaaf21 (Fix du fonctionnement de Either et Either dans Repeat):src/exec.ml
=======
            | [] -> state.position, rest
            | first_instr :: remaining_choice -> 
              (match first_instr with
              | Move transform -> Geo.transform transform state.position, remaining_choice @ rest
              | _ -> state.position, remaining_choice @ rest))
>>>>>>> ae0d4f2 (rect fonctionnel):src/exec.ml
      in
      let new_state = { state with position = new_position; program = new_program } 
      in Some new_state
;;

let execute_step_rect (state_rect : state_rect) : state_rect option =
  match state_rect.program with
  | [] -> None
  | instr :: rest ->
    let new_rectangle, new_program = 
      match instr with
      | Move transform -> transform_rect transform state_rect.rect, rest 
      | Repeat (n, sub_prog) when n > 1 -> 
        (match sub_prog with
        | [] -> state_rect.rect, rest 
        | first_instr :: remaining_sub_prog -> 
          let intermediate_position, updated_sub_prog = 
            match first_instr with
            | Move transform -> transform_rect transform state_rect.rect, remaining_sub_prog
            | Either (choice1, choice2) -> 
              let selected_choice = 
                if Random.bool () then 
                  choice1 
                else 
                  choice2 
              in
              (match selected_choice with
              | [] -> state_rect.rect, remaining_sub_prog
              | choice_first :: choice_rest ->
                (match choice_first with
                | Move transform -> transform_rect transform state_rect.rect, choice_rest @ remaining_sub_prog
                | _ -> state_rect.rect, remaining_sub_prog))
            | _ -> state_rect.rect, remaining_sub_prog
          in intermediate_position, updated_sub_prog @ [Repeat (n - 1, sub_prog)] @ rest)

      | Repeat (_, sub_prog) -> 
        (match sub_prog with
        | [] -> state_rect.rect, rest
        | first_instr :: remaining_sub_prog -> 
          let intermediate_position, updated_sub_prog = 
            match first_instr with
            | Move transform -> transform_rect transform state_rect.rect, remaining_sub_prog
            | Either (choice1, choice2) -> 
              let selected_choice = 
                if Random.bool () then 
                  choice1 
                else 
                  choice2 
              in
              (match selected_choice with
              | [] -> state_rect.rect, remaining_sub_prog
              | choice_first :: choice_rest ->
                (match choice_first with
                | Move transform -> transform_rect transform state_rect.rect, choice_rest @ remaining_sub_prog
                | _ -> state_rect.rect, remaining_sub_prog))
          | _ -> state_rect.rect, remaining_sub_prog
        in intermediate_position, updated_sub_prog @ rest)

      | Either (choice1, choice2) -> 
        let selected_choice = 
          if Random.bool () then 
            choice1 
          else 
            choice2 
          in
          (match selected_choice with
          | [] -> state_rect.rect, rest
          | first_instr :: remaining_choice -> 
            (match first_instr with
            | Move transform -> transform_rect transform state_rect.rect, remaining_choice @ rest
            | _ -> state_rect.rect, remaining_choice @ rest))
      in
      let new_state = { state_rect with rect = new_rectangle; program = new_program } 
      in Some new_state
;;

let rec run_program (state : state) (delay : float) (cmd : Read.command) : unit = 
  match execute_step state with
  | None -> () 
  | Some new_state -> 
      print_endline "Exécution d'une étape du prog :";
      Unix.sleepf delay;
      let display = configure_display cmd true
      in 
      let (x, y) =
        ( 
          ((new_state.position.x *. 2.) *. float_of_int display.scale) +. float_of_int display.width,
          ((new_state.position.y *. 2.) *. float_of_int display.scale) +. float_of_int display.height
        )
      in draw_point (int_of_float x) (int_of_float y) display.scale cmd;
      Printf.printf "Position du point : (%f, %f)\n" new_state.position.x new_state.position.y;
      run_program new_state delay cmd
;;

let rec run_program_rect (state_rect : state_rect) (delay : float) (cmd : Read.command) : unit = 
  match execute_step_rect state_rect with
  | None -> () 
  | Some new_state -> 
    print_endline "Exécution d'une étape du prog :";
    Unix.sleepf delay;
    let display = configure_display cmd true
    in 
    draw_rectangle { 
      x_min = (new_state.rect.x_min *. float_of_int display.scale) +. float_of_int (display.width / 2);
      y_min = (new_state.rect.y_min *. float_of_int display.scale) +. float_of_int (display.height / 2);
      x_max = (new_state.rect.x_max *. float_of_int display.scale) +. float_of_int (display.width / 2); 
      y_max = (new_state.rect.y_max *. float_of_int display.scale) +. float_of_int (display.height / 2);
    } display.scale cmd;
    Printf.printf "Position du rectangle : (x_min = %f, x_max = %f, y_min = %f, y_max = %f)\n" new_state.rect.x_min new_state.rect.x_max new_state.rect.y_min new_state.rect.y_max;
    run_program_rect new_state delay cmd
;;