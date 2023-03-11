type error = RPCError(string) | BadParams
type rpcResult<'a> = AsyncResult.t<'a, error>

type api = {
  echo: (. string) => rpcResult<string>,
  ping: (. unit) => rpcResult<string>,
  add: (. int, int) => rpcResult<int>,
  divide: (. int, int) => rpcResult<int>,
  nothing: (. unit) => rpcResult<unit>,
}

module RPC = RescriptRPC.Make({
  type api = api
  type error = error

  let onInternalError = error =>
    switch error {
    | RescriptRPC_Error.ClientEncodingError => RPCError("client encoding error")
    | RescriptRPC_Error.ClientDecodingError => RPCError("client decoding error")
    | RescriptRPC_Error.ClientNetworkingError => RPCError("client networking error")
    | RescriptRPC_Error.ServerEncodingError => RPCError("server encoding error")
    | RescriptRPC_Error.ServerDecodingError => RPCError("server decoding error")
    | RescriptRPC_Error.ServerMissingProcedureError => RPCError("server missing procedure error")
    | RescriptRPC_Error.ServerBodyParserError => RPCError("server body parser error")
    }
})
