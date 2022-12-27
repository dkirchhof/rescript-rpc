module RPC = RescriptRPC.Make({
  type api = Api.t
  type error = Api.rpcError

  let onInternalError = error =>
    switch error {
    | Error.ClientEncodingError => Api.RPCError("can't encode body")
    | Error.ClientDecodingError => Api.RPCError("can't decode response")
    | Error.ClientNetworkingError => Api.RPCError("can't fetch")
    }
})

let client = RPC.makeClient("http://localhost:3000/rpc")

client.add(. 2, 4)->AsyncResult.forEach(result =>
  switch result {
  | Ok(r) => Js.log("result: " ++ Belt.Int.toString(r))
  | Error(e) => Js.log(e)
  }
)
