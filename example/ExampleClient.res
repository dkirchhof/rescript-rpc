let client = Api.RPC.makeClient("http://localhost:3000/rpc")

client.echo(. "hello")->AsyncResult.forEach(result =>
  switch result {
  | Ok(r) => Js.log("result: " ++ r)
  | Error(e) => Js.log(e)
  }
)

client.ping(.)->AsyncResult.forEach(result =>
  switch result {
  | Ok(r) => Js.log("result: " ++ r)
  | Error(e) => Js.log(e)
  }
)

client.divide(. 10, 2)->AsyncResult.forEach(result =>
  switch result {
  | Ok(r) => Js.log("result: " ++ Belt.Int.toString(r))
  | Error(e) => Js.log(e)
  }
)

client.divide(. 10, 0)->AsyncResult.forEach(result =>
  switch result {
  | Ok(r) => Js.log("result: " ++ Belt.Int.toString(r))
  | Error(e) =>
    switch e {
    | Api.RPCError(message) => Js.log("error: " ++ message)
    | Api.BadParams => Js.log("error: bad params")
    }
  }
)
