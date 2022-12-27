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

let encode = (payload, onError) => {
  let maybeJson = JSON.encode(payload)

  switch maybeJson {
  | Some(json) => AsyncResult.ok(json)
  | None => onError(Error.ClientEncodingError)->AsyncResult.error
  }
}

let fetch = (endpoint, body, onError) => {
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
      onError(Error.ClientNetworkingError)->Error
    }
  )
  ->Promise.catch(_ => onError(Error.ClientNetworkingError)->Error)
}

let getText = (response, onError) => {
  Fetch.Response.text(response)->AsyncResult.fromPromise(_ => onError(Error.ClientNetworkingError))
}

let decode = (json, onError) => {
  let maybeObj = JSON.decode(json)

  switch maybeObj {
  | Some(obj) => AsyncResult.ok(obj)
  | None => onError(Error.ClientDecodingError)->AsyncResult.error
  }
}
