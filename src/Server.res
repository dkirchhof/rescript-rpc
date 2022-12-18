module type Api = {
  type t

  let api: t
}

module Make = (Api: Api) => {
  let api = Api.api

  let getBody: (Api.t, NodeJS.Request.t) => promise<Body.t<_>> = %raw(`
    function(decode, api, req) {
      return new Promise((resolve) => {
        const chunks = [];

        req.on("data", chunk => chunks.push(chunk));

        req.on("end", () => {
          const buffer = Buffer.concat(chunks).toString();
          const body = decode(buffer);
          
          resolve(body); 
        });
      });
    }
  `)(JSON.decode)

  let callProcedureExn: (Api.t, Body.t<_>) => 'b = %raw(`
    function(api, body) {
      return api[body.procedure](...body.params);
    }
  `)
}
