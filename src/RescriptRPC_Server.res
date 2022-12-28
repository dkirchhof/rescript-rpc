let getBody_: RescriptRPC_NodeJS.Request.t => promise<string> = %raw(`
  function(req) {
    return new Promise((resolve) => {
      const chunks = [];

      req.on("data", chunk => chunks.push(chunk));

      req.on("end", () => {
        const buffer = Buffer.concat(chunks).toString();
        
        resolve(buffer); 
      });
    });
  }
`)

let getBody = (req, onError) => {
  getBody_(req)->AsyncResult.fromPromise(_ => onError(RescriptRPC_Error.ServerBodyParserError))
}

let callProcedure_: ('a, RescriptRPC_Body.t<'b>) => 'c = %raw(`
  function(api, body) {
    return api[body.procedure](...body.params);
  }
`)

let callProcedure = (handlers, body, onError) => {
  try {
    callProcedure_(handlers, body)
  } catch {
  | _ => onError(RescriptRPC_Error.ServerMissingProcedureError)->AsyncResult.error
  }
}

let decode = (json, onError) => {
  let maybeData = RescriptRPC_JSON.decode(json)

  switch maybeData {
  | Some(data) => AsyncResult.ok(data)
  | None => onError(RescriptRPC_Error.ServerDecodingError)->AsyncResult.error
  }
}

let encode = (data, onError) => {
  let maybeJson = RescriptRPC_JSON.encode(data)

  switch maybeJson {
  | Some(json) => AsyncResult.ok(json)
  | None => onError(RescriptRPC_Error.ServerEncodingError)->AsyncResult.error
  }
}
