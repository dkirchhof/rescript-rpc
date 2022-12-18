module Response = {
  type t = {ok: bool}

  @send external json: t => Promise.t<'t> = "json"
}

type options = {method: [#POST], body: string}

external make: (string, options) => Promise.t<Response.t> = "fetch"
