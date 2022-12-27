module type RPC = {
  type api
  type error

  let onInternalError: Error.t => error
}

module Make = (RPC: RPC) => {
  let makeClient: string => RPC.api = endpoint =>
    Client.makeProxy((procedure, params) => {
      Client.encode(
        {
          Body.procedure,
          Body.params,
        },
        RPC.onInternalError,
      )
      ->AsyncResult.flatMapOk(Client.fetch(endpoint, _, RPC.onInternalError))
      ->AsyncResult.flatMapOk(Client.getText(_, RPC.onInternalError))
      ->AsyncResult.flatMapOk(Client.decode(_, RPC.onInternalError))
    })

  let handleRequest = (api: RPC.api, req, res) => {
    NodeJS.Response.setHeader(res, "Content-Type", "application/json")

    Server.getBody(req, RPC.onInternalError)
    ->AsyncResult.flatMapOk(Server.decode(_, RPC.onInternalError))
    ->AsyncResult.flatMapOk(Server.callProcedure(api, _, RPC.onInternalError))
    ->AsyncResult.forEach(result => {
      let maybeJson = result->JSON.encode

      switch maybeJson {
        | Some(json) => NodeJS.Response.endWithData(res, json)
        | None => NodeJS.Response.endWithData(res, JSON.encodeUnsafe(RPC.onInternalError))
      } 
    })
  }
}
