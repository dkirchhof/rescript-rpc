type t<'a> = Js.Promise2.t<'a>

let make = Js.Promise2.make
let resolve = Js.Promise2.resolve

@send external then: (t<'a>, 'a => 'b) => t<'b> = "then"
@send external catch: (t<'a>, 'b => unit) => t<'a> = "catch"
