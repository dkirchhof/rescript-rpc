module Response = {
  type t = {ok: bool}

  @send external text: t => promise<string> = "json"
}

type options = {method: [#POST], body: string}

external fetch: (string, options) => promise<Response.t> = "fetch"
