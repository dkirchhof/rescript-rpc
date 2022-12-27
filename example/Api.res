type error = RPCError(string) | BadParams
type rpcResult<'a> = AsyncResult.t<'a, error>

type api = {
  echo: (. string) => rpcResult<string>,
  ping: (. unit) => rpcResult<string>,
  add: (. int, int) => rpcResult<int>,
  divide: (. int, int) => rpcResult<int>,
}

module RPC = RescriptRPC.Make({
  type api = api
  type error = error

  let onInternalError = error =>
    switch error {
    | Error.ClientEncodingError => RPCError("client encoding error")
    | Error.ClientDecodingError => RPCError("client decoding error")
    | Error.ClientNetworkingError => RPCError("client networking error")
    | Error.ServerEncodingError => RPCError("server encoding error")
    | Error.ServerDecodingError => RPCError("server decoding error")
    | Error.ServerMissingProcedureError => RPCError("server missing procedure error")
    | Error.ServerBodyParserError => RPCError("server body parser error")
    }
})
