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

let encode = (data, onError) => {
  let maybeJson = JSON.encode(data)

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
      headers: {
        "Content-Type": "application/json",
      },
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
  let maybeData = JSON.decode(json)
  Js.log(maybeData)

  switch maybeData {
  | Some(data) => Promise.resolve(data)
  | None => onError(Error.ClientDecodingError)->AsyncResult.error
  }
}
