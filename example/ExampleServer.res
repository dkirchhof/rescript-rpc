let server = NodeJS.Server.make((req: NodeJS.Request.t, res: NodeJS.Response.t) => {
  if req.url === "/rpc" {
    if req.method === #POST {
      // set cors

      Api.RPC.handleRequest(
        {
          echo: (. message) => AsyncResult.ok(message),
          ping: (. ()) => AsyncResult.ok("pong"),
          add: (. a, b) => AsyncResult.ok(a + b),
          divide: (. a, b) => {
            if b === 0 {
              AsyncResult.error(Api.BadParams)
            } else {
              AsyncResult.ok(a / b)
            }
          },
        },
        req,
        res,
      )
    } else {
      NodeJS.Response.writeHead(res, 405)
      NodeJS.Response.end(res)
    }
  } else {
    NodeJS.Response.writeHead(res, 404)
    NodeJS.Response.end(res)
  }
})

NodeJS.Server.listen(server, 3000, "localhost", () => {
  Js.log("server is running")
})
