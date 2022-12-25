module Helpers = {
  let makeProxy: ((string, 'params) => 'c) => 'd = %raw(`
  function(handler) {
    return new Proxy({}, {
      get: (_, procedure) => {
        return async function(...params) {
          return handler(procedure, params);
        }
      }
    });
  }
`)

  let encode = payload => {
    let maybeJson = JSON.encode(payload)

    switch maybeJson {
    | Some(json) => AsyncResult.ok(json)
    | None => AsyncResult.error(RPCError.ClientError("can't encode payload"))
    }
  }

  let fetch = (endpoint, body) => {
    Fetch.fetch(
      endpoint,
      {
        method: #POST,
        body,
      },
    )
    ->Promise.map(response =>
      if response.ok {
        Ok(response)
      } else {
        Error(RPCError.ClientError("failed to fetch"))
      }
    )
    ->Promise.catch(_ => Error(RPCError.ClientError("failed to fetch")))
  }

  let getText = response => {
    Fetch.Response.text(response)->AsyncResult.fromPromise(_ => RPCError.ClientError(
      "can't get text from response",
    ))
  }

  let decode = json => {
    let maybeObj = JSON.decode(json)

    switch maybeObj {
    | Some(obj) => AsyncResult.ok(obj)
    | None => AsyncResult.error(RPCError.ClientError("can't decode response"))
    }
  }
}

let make = endpoint =>
  Helpers.makeProxy((procedure, params) => {
    Helpers.encode({
      Body.procedure,
      Body.params,
    })
    ->AsyncResult.flatMapOk(Helpers.fetch(endpoint, _))
    ->AsyncResult.flatMapOk(Helpers.getText)
    ->AsyncResult.flatMapOk(Helpers.decode)
  })
