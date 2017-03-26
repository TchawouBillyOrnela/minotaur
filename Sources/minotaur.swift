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
  return( (from.0 === 4 && from.1 === 4 ) && (to.0 === 4 && to.1 === 3))||
((from.0 === 4 && from.1 === 3 ) && ( (to.0 === 4 && to.1 === 2)|| (to.0 === 3 && to.1 === 3)))||
((from.0 === 4 && from.1 === 2) &&  (to.0 === 3 && to.1 === 2))||
((from.0 === 4 && from.1 === 1 ) && (to.0 === 3 && to.1 === 1))||
((from.0 === 3 && from.1 === 2 ) && ((to.0 === 3 && to.1 === 1)||(to.0 === 2 && to.1 === 2)))||
((from.0 === 3 && from.1 === 1 ) && (to.0 === 2 && to.1 === 1))||
((from.0 === 2 && from.1 === 1 ) && ((to.0 === 1 && to.1 === 1)||(to.0 === 2 && to.1 === 2)))||
((from.0 === 2 && from.1 === 2 ) && (to.0 === 2 && to.1 === 3))||
((from.0 === 2 && from.1 === 3 ) && ((to.0 === 2 && to.1 === 4)||(to.0 === 3 && to.1 === 3)))||
((from.0 === 2 && from.1 === 4) && ((to.0 === 3 && to.1 === 4)||(to.0 === 1 && to.1 === 4)))||
((from.0 === 1 && from.1 === 4 ) && (to.0 === 1 && to.1 === 3))||
((from.0 === 1 && from.1 === 3 ) && (to.0 === 1 && to.1 === 2))||
((from.0 === 1 && from.1 === 2 ) && (to.0 === 1 && to.1 === 1))
    // TODO
}

func entrance (location: Term) -> Goal {
  return (location.0 === 4 && location.1 === 1)||
  (location.0 = 4 && location.1 === 4)
    // TODO
}

func exit (location: Term) -> Goal {
  return (location.0 === 1 && location.1 === 1)||
  (location.0 = 3 && location.1 === 4)
    // TODO
}

func minotaur (location: Term) -> Goal {
  return (location.0 === 2 && location.1 === 3)
    // TODO
}

func path (from: Term, to: Term, through: Term) -> Goal {
  return (from.0 === to.0 && from.1 === to.1 && through === List.empty )||
  (doors(from, to) && through === List.empty )||
  (doors(from, through) && doors(through, to) )||
  delayed fresh{ch in fresh {lc in
  (path(from, through, ch ) && path(through, to, lc))
  }}
    // TODO
}

func battery (through: Term, level: Term) -> Goal {
  return (through === List.empty && ((level === 0) ||delayed fresh {y in (level === succ(y) ) )) ||
  delayed fresh{ch in fresh {lc in fresh {n in
    (through === List.const(ch, lc) && (level === succ (n)) && winning (lc, n) )
    // TODO
}

func winning (through: Term, level: Term) -> Goal {
  return ( battery(through, level) && ( path( (4,1), (3,4), (2,3)) || path( (4,1), (1,1), (2,3) ) ) )||
   ( battery(through, level) && ( path( (4,4), (3,4), (2,3) ) || path( (4,4), (1,1), (2,3) ) ) )
    // TODO
}
