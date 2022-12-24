let client: Api.t = Client.make("http://localhost:3000/rpc")

/* client.echo(. "hello") */
/* ->Promise.then(r => { */
/* Js.log(r) */
/* }) */
/* ->ignore */

/* client.ping(.) */
/* ->Promise.then(r => { */
/* Js.log(r) */
/* }) */
/* ->ignore */

client.add(. 2, 4)->AsyncResult.forEach(result =>
  switch result {
  | Ok(r) => Js.log("result: " ++ Belt.Int.toString(r))
  | Error(e) => Js.log(e)
  }
)
