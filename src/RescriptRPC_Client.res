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
  let maybeJson = RescriptRPC_JSON.encode(data)

  switch maybeJson {
  | Some(json) => AsyncResult.ok(json)
  | None => onError(RescriptRPC_Error.ClientEncodingError)->AsyncResult.error
  }
}

let fetch = (endpoint, body, onError) => {
  RescriptRPC_Fetch.fetch(
    endpoint,
    {
      method: #POST,
      headers: {
        "Content-Type": "application/json",
      },
      body,
    },
  )
  ->RescriptRPC_Promise.map(response =>
    if response.ok {
      Ok(response)
    } else {
      onError(RescriptRPC_Error.ClientNetworkingError)->Error
    }
  )
  ->RescriptRPC_Promise.catch(_ => onError(RescriptRPC_Error.ClientNetworkingError)->Error)
}

let getText = (response, onError) => {
  RescriptRPC_Fetch.Response.text(response)->AsyncResult.fromPromise(_ =>
    onError(RescriptRPC_Error.ClientNetworkingError)
  )
}

let decode = (json, onError) => {
  let maybeData = RescriptRPC_JSON.decode(json)

  switch maybeData {
  | Some(data) => AsyncResult.ok(data)
  | None => onError(RescriptRPC_Error.ClientDecodingError)->AsyncResult.error
  }
}
