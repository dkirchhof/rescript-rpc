let handleRequest = (api, req, res) => {
  req
  ->Body.parse
  ->Promise.then(body => {
    let fn = api->Obj.magic->Js.Dict.get(body.procedure)

    switch fn {
    | Some(fn) =>
      fn(body.payload)->Promise.then(result => {
        let json = result->Js.Json.stringifyAny->Belt.Option.getExn

        res->NodeJS.Response.setHeader("Content-Type", "application/json");
        res->NodeJS.Response.endWithData(json)
      })
    | None => {
        res->NodeJS.Response.writeHead(500)
        res->NodeJS.Response.endWithData("not implemented yet")

        Promise.resolve()
      }
    }
  })
}
