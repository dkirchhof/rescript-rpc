type t<'payload> = {
  procedure: string,
  payload: 'payload,
}

let make = (procedure, payload) => {
  {procedure, payload}->Js.Json.stringifyAny->Belt.Option.getExn
}

let parse = req => {
  Promise.make((~resolve, ~reject as _) => {
    let chunks = []

    req->NodeJS.Request.on(
      #data(
        chunk => {
          Js.Array2.push(chunks, chunk)->ignore
        },
      ),
    )

    req->NodeJS.Request.on(
      #end(
        () => {
          let body: t<_> = chunks->Node.Buffer.concat->Node.Buffer.toString->Js.Json.parseExn->Obj.magic

          resolve(. body)
        },
      ),
    )
  })
}
