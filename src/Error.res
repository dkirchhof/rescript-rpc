/* type t = ClientError(string) | ServerError(string) */

/* @send external cause: Js.Exn.t => string = "cause" */ 

/* let makeClientErrorFromJSExn = exn => */
/*   exn->Js.Exn.message->Belt.Option.getWithDefault("Unknown error")->ClientError */

/* let makeServerErrorFromJSExn = exn => */
/*   exn->Js.Exn.message->Belt.Option.getWithDefault("Unknown error")->ServerError */

type t = ClientEncodingError | ClientDecodingError | ClientNetworkingError
