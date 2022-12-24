type t = {
  echo: (. string) => RPCResult.t<string>,
  ping: (. unit) => RPCResult.t<string>,
  add: (. int, int) => RPCResult.t<int>,
}
