type rpcError = RPCError(string) | Unauthorized | Forbidden
type rpcResult<'a> = AsyncResult.t<'a, rpcError>

type t = {
  echo: (. string) => rpcResult<string>,
  ping: (. unit) => rpcResult<string>,
  add: (. int, int) => rpcResult<int>,
}
