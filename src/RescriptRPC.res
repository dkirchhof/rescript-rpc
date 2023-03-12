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
      ->AsyncResult.flatMap(text => {
        if text === "" {
          AsyncResult.ok()
        } else {
          RescriptRPC_Client.decode(text, RPC.onInternalError)
        }
      })
    })

  let handleRequest = (api: RPC.api, req, res) => {
    RescriptRPC_NodeJS.Response.setHeader(res, "Content-Type", "application/json")

    RescriptRPC_Server.getBody(req, RPC.onInternalError)
    ->AsyncResult.flatMap(RescriptRPC_Server.decode(_, RPC.onInternalError))
    ->AsyncResult.flatMap(RescriptRPC_Server.callProcedure(api, _, RPC.onInternalError))
    ->AsyncResult.forEachBoth(
      RescriptRPC_Server.sendResponse(_, res, RPC.onInternalError),
      RescriptRPC_Server.sendResponse(_, res, RPC.onInternalError),
    )
  }
}
