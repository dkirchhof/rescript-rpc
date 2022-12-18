module Server = Server.Make({
  type t = Api.t

  let api: t = {
    echo: (. message) => Promise.resolve(message),
    ping: (. ()) => Promise.resolve("pong"),
    add: (. a, b) => Promise.resolve(a + b),
  }
})

let server = NodeJS.Server.make((req: NodeJS.Request.t, res: NodeJS.Response.t) => {
  if req.url === "/rpc" {
    if req.method === #POST {
      Server.api
      ->Server.getBody(req)
      ->Promise.then(body => Server.api->Server.callProcedureExn(body))
      ->Promise.then(result => {
        let json = JSON.encode(result)

        NodeJS.Response.setHeader(res, "Content-Type", "application/json")
        NodeJS.Response.endWithData(res, json)
      })
      ->Promise.catch(error => {
        NodeJS.Response.writeHead(res, 400)
        NodeJS.Response.endWithData(res, Js.Exn.message(error)->Belt.Option.getUnsafe)
      })
      ->ignore
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
