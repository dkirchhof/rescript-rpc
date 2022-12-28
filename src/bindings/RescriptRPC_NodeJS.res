include Node

module Request = {
  type t = {url: string, method: [#POST | #OPTIONS]}

  @send
  external on: (
    t,
    @string
    [
      | #data(Buffer.t => unit)
      | #end(unit => unit)
    ],
  ) => unit = "on"
}

module Response = {
  type t

  @send external writeHead: (t, int) => unit = "writeHead"
  @send external setHeader: (t, string, string) => unit = "setHeader"
  @send external end: t => unit = "end"
  @send external endWithData: (t, string) => unit = "end"
}

module Server = {
  type t

  @module("http") external make: ((Request.t, Response.t) => unit) => t = "createServer"

  @send external listen: (t, int, string, unit => unit) => unit = "listen"
}
