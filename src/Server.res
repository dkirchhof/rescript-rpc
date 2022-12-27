let getBody_: NodeJS.Request.t => promise<string> = %raw(`
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
  getBody_(req)->AsyncResult.fromPromise(_ => onError(Error.ServerBodyParserError))
}

let callProcedure_: ('a, Body.t<'b>) => 'c = %raw(`
  function(api, body) {
    return api[body.procedure](...body.params);
  }
`)

let callProcedure = (handlers, body, onError) => {
  try {
    callProcedure_(handlers, body)
  } catch {
  | _ => onError(Error.ServerMissingProcedureError)->AsyncResult.error
  }
}

let decode = (json, onError) => {
  let maybeData = JSON.decode(json)

  switch maybeData {
  | Some(data) => AsyncResult.ok(data)
  | None => onError(Error.ServerDecodingError)->AsyncResult.error
  }
}

let encode = (data, onError) => {
  let maybeJson = JSON.encode(data)

  switch maybeJson {
  | Some(json) => AsyncResult.ok(json)
  | None => onError(Error.ServerEncodingError)->AsyncResult.error
  }
}
