let server = RescriptRPC_NodeJS.Server.make((req: RescriptRPC_NodeJS.Request.t, res: RescriptRPC_NodeJS.Response.t) => {
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
          nothing: (. ()) => AsyncResult.ok(),
        },
        req,
        res,
      )
    } else {
      RescriptRPC_NodeJS.Response.writeHead(res, 405)
      RescriptRPC_NodeJS.Response.end(res)
    }
  } else {
    RescriptRPC_NodeJS.Response.writeHead(res, 404)
    RescriptRPC_NodeJS.Response.end(res)
  }
})

RescriptRPC_NodeJS.Server.listen(server, 3000, "localhost", () => {
  Js.log("server is running")
})
