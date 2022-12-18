let make = endpoint => {
  Proxy.make(
    Js.Obj.empty(),
    {
      get: (_, p) => {
        (. payload) =>
          Fetch.make(
            endpoint,
            {
              method: #POST,
              body: Body.make(p, payload),
            },
          )
          ->Promise.then(response => {
            response->Fetch.Response.json
          })
      },
    },
  )
}
