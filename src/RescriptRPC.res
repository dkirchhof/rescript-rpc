module type RPC = {
  type api
  type error

  let onInternalError: RescriptRPC_Error.t => error
}

module Make = (RPC: RPC) => {
  let makeClient: string => RPC.api = endpoint =>
    RescriptRPC_Client.makeProxy((procedure, params) => {
      let body: RescriptRPC_Body.t<_> = {
        procedure,
        params,
      }

      RescriptRPC_Client.encode(body, RPC.onInternalError)
      ->AsyncResult.flatMap(RescriptRPC_Client.fetch(endpoint, _, RPC.onInternalError))
      ->AsyncResult.flatMap(RescriptRPC_Client.getText(_, RPC.onInternalError))
      ->AsyncResult.flatMap(RescriptRPC_Client.decode(_, RPC.onInternalError))
      ->AsyncResult.flatMap(result => result)
    })

  let handleRequest = (api: RPC.api, req, res) => {
    RescriptRPC_NodeJS.Response.setHeader(res, "Content-Type", "application/json")

    RescriptRPC_Server.getBody(req, RPC.onInternalError)
    ->AsyncResult.flatMap(RescriptRPC_Server.decode(_, RPC.onInternalError))
    ->AsyncResult.flatMap(RescriptRPC_Server.callProcedure(api, _, RPC.onInternalError))
    ->AsyncResult.forEachBoth(
      error => error->Error->RescriptRPC_Server.sendResponse(res, RPC.onInternalError),
      result => result->Ok->RescriptRPC_Server.sendResponse(res, RPC.onInternalError),
    )
  }
}
