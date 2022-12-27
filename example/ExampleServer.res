module RPCServer = Server.Make({
  type t = Api.t

  let api: t = {
    echo: (. message) => Promise.resolve(message)->Obj.magic,
    ping: (. ()) => Promise.resolve("pong")->Obj.magic,
    add: (. a, b) => Promise.resolve(a + b)->Obj.magic,
  }
})

let server = NodeJS.Server.make((req: NodeJS.Request.t, res: NodeJS.Response.t) => {
  if req.url === "/rpc" {
    if req.method === #POST {
      RPCServer.api
      ->RPCServer.getBody(req)
      ->Promise.map(body => RPCServer.api->RPCServer.callProcedureExn(body))
      ->Promise.map(result => {
        let json = JSON.encode(result)

        NodeJS.Response.setHeader(res, "Content-Type", "application/json")
        NodeJS.Response.endWithData(res, json->Belt.Option.getExn)
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
