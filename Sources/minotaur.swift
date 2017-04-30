import LogicKit

let zero = Value (0)

func succ (_ of: Term) -> Map {
    return ["succ": of]
}

func toNat (_ n : Int) -> Term {
    var result : Term = zero
    for _ in 1...n {
        result = succ (result)
    }
    return result
}

struct Position : Equatable, CustomStringConvertible {
    let x : Int
    let y : Int

    var description: String {
        return "\(self.x):\(self.y)"
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
      return lhs.x == rhs.x && lhs.y == rhs.y
    }

}


// rooms are numbered:
// x:1,y:1 ... x:n,y:1
// ...             ...
// x:1,y:m ... x:n,y:m
func room (_ x: Int, _ y: Int) -> Term {
  return Value (Position (x: x, y: y))
}

func doors (from: Term, to: Term) -> Goal {
  return//on retourne les couples de pieces a et b tels que il ya une porte de a à b
    (from === room(4,4) && to === room(3,4)) ||
    (from === room(3,4) && to === room(2,4)) ||
    (from === room(3,4) && to === room(3,3)) ||
    (from === room(2,4) && to === room(2,3)) ||
    (from === room(1,4) && to === room(1,3)) ||
    (from === room(2,3) && to === room(1,3)) ||
    (from === room(2,3) && to === room(2,2)) ||
    (from === room(1,3) && to === room(1,2)) ||
    (from === room(1,2) && to === room(1,1)) ||
    (from === room(1,2) && to === room(2,2)) ||
    (from === room(2,2) && to === room(3,2)) ||
    (from === room(3,2) && to === room(4,2)) ||
    (from === room(3,2) && to === room(3,3)) ||
    (from === room(4,2) && to === room(4,3)) ||
    (from === room(4,2) && to === room(4,1)) ||
    (from === room(4,1) && to === room(3,1)) ||
    (from === room(3,1) && to === room(2,1)) ||
    (from === room(2,1) && to === room(1,1))
    // TODO
}

func entrance (location: Term) -> Goal {
  return
    location === room(1,4) || location === room(4,4)
    // TODO
}

func exit (location: Term) -> Goal {
  return
    location === room(1,1) || location === room(4,3)
    // TODO
}

func minotaur (location: Term) -> Goal {
  return
    location === room (3,2)
    // TODO
}

func path (from: Term, to: Term, through: Term) -> Goal {
  return
    (from === to && through === List.empty) ||
    delayed (
      fresh { ch in
        fresh { lc in
          (through === List.cons(ch,lc) &&
          doors(from: from, to: ch) &&
          path(from: ch, to: to, through: lc))
        }
      }
    )

    // TODO
}

func battery (through: Term, level: Term) -> Goal {
  return
    delayed (
      fresh { y in
        level === succ(y) &&
        ( (through === List.empty) ||
        delayed (
          fresh { ch in
            fresh { lc in
              fresh { n in
                (through === List.cons(ch,lc) && level === succ (n) && battery(through: lc, level: n))
              }
            }
          }
        )
      )
    }
  )
    // TODO
}

let way1 = List.cons(room(1,4),List.cons(room(1,3),List.cons(room(1,2),List.cons(room(2,2),List.cons(room(3,2),List.cons(room(4,2),List.cons(room(4,3),List.empty)))))))
let way2 = List.cons(room(1,4), List.cons(room(1,3),List.cons(room(1,2),List.cons(room(2,2),List.cons(room(3,2),List.cons(room(4,2),List.cons(room(4,1),List.cons(room(3,1),List.cons(room(2,1),List.cons(room(1,1),List.empty))))))))))
let way3 = List.cons(room(4,4), List.cons(room(3,4),List.cons(room(2,4),List.cons(room(2,3),List.cons(room(2,2),List.cons(room(3,2),List.cons(room(4,2),List.cons(room(4,1),List.cons(room(3,1),List.cons(room(2,1),List.cons(room(1,1),List.empty)))))))))))
let way4 = List.cons(room(4,4), List.cons(room(3,4),List.cons(room(2,4),List.cons(room(2,3),List.cons(room(1,3),List.cons(room(1,2),List.cons(room(2,2),List.cons(room(3,2),List.cons(room(4,2),List.cons(room(4,1),List.cons(room(3,1),List.cons(room(2,1),List.cons(room(1,1),List.empty)))))))))))))
let way5 = List.cons(room(4,4), List.cons(room(3,4),List.cons(room(2,4),List.cons(room(2,3),List.cons(room(2,2),List.cons(room(3,2),List.cons(room(4,2),List.cons(room(4,3),List.empty))))))))
let way6 = List.cons(room(4,4), List.cons(room(3,4),List.cons(room(2,4),List.cons(room(2,3),List.cons(room(1,3),List.cons(room(1,2),List.cons(room(2,2),List.cons(room(3,2),List.cons(room(4,2),List.cons(room(4,3),List.empty))))))))))
func winning (through: Term, level: Term) -> Goal {
  return
    through === way1 && level === toNat (7) ||
    through === way2 && level === toNat (10) ||
    through === way3 && level === toNat (11) ||
    through === way4 && level === toNat (13) ||
    through === way5 && level === toNat (8) ||
    through === way6 && level === toNat (10)


    // TODO
}
