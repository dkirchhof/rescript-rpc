let client: Api.t = Client.make("http://localhost:3000/rpc")

client.echo("hello")->Promise.then(r => {
  Js.log(r)
})->ignore

client.ping()->Promise.then(r => {
  Js.log(r)
})->ignore
