let api = (url) => {
  Api.echo: message => Promise.resolve(`${message} from ${url}`),
  ping: () => Promise.resolve("pong"),
}

let server = NodeJS.Server.make((req, res) => {
  if req.url === "/rpc" {
    if req.method === #POST {
      api(req.url)->Server.handleRequest(req, res)->ignore
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
