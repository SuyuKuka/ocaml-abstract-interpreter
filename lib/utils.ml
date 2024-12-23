<<<<<<< HEAD:lib/utils.ml
open Geo;;
open Interp;;

let program1 () : program = 
  [
    Move (
      Translate (
        { x = 0.5; y = 1. }
      )
    )
  ];;

let program2 () : program = 
  [
    Repeat (3, 
      [
        Move (
          Translate (
            { x = 1.; y = 1. }
          )
        )
      ]
    )
  ];;

let program3 () : program = 
  [
    Repeat (5, 
      [
        Either (
          [
            Move (
              Translate (
                { x = 0.; y = 1. }
              )
            )
          ], 
          [
            Move (
              Rotate (
                { x = 0.; y = 0.}, 45.
              )
            )
          ]
        )
      ]
    )
=======
open Geo;;
open Interp;;

let program1 () : program = 
  [
    Move (
      Translate (
        { x = 0.5; y = 1. }
      )
    )
  ];;

let program2 () : program = 
  [
    Repeat (3, 
      [
        Move (
          Translate (
            { x = 1.; y = 1. }
          )
        )
      ]
    )
  ];;

let program3 () : program = 
  [
    Repeat (5, 
      [
        Either (
          [
            Move (
              Translate (
                { x = 0.; y = 1. }
              )
            )
          ], 
          [
            Move (
              Rotate (
                { x = 0.; y = 0.}, 45.
              )
            )
          ]
        )
      ]
    )
>>>>>>> d2565a8253cf41a78a0a3095b981e0df89e3652c:src/utils.ml
  ];;