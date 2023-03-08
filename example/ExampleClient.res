let client = Api.RPC.makeClient("http://localhost:3000/rpc")

client.echo(. "hello")->AsyncResult.forEachBoth(
  error => Js.log(error),
  result => Js.log("result: " ++ result),
)

client.ping(.)->AsyncResult.forEachBoth(
  error => Js.log(error),
  result => Js.log("result: " ++ result),
)

client.divide(. 10, 2)->AsyncResult.forEachBoth(
  error => Js.log(error),
  result => Js.log("result: " ++ Belt.Int.toString(result)),
)

client.divide(. 10, 0)->AsyncResult.forEachBoth(
  error => {
    switch error {
    | Api.RPCError(message) => Js.log("error: " ++ message)
    | Api.BadParams => Js.log("error: bad params")
    }
  },
  result => Js.log("result: " ++ Belt.Int.toString(result)),
)
