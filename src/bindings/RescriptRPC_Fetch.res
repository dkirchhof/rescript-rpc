module Response = {
  type t = {ok: bool}

  @send external text: t => promise<string> = "text"
}

type options = {method: [#POST], headers: {"Content-Type": string}, body: string}

external fetch: (string, options) => promise<Response.t> = "fetch"
