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
}
