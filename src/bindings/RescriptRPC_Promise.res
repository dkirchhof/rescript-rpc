type t<'a> = promise<'a>

let make = Js.Promise2.make
let resolve = Js.Promise2.resolve

@send external map: (t<'a>, 'a => 'b) => t<'b> = "then"
@send external flatMap: (t<'a>, 'a => t<'b>) => t<'b> = "then"
@send external catch: (t<'a>, 'b => 'c) => t<'a> = "catch"
