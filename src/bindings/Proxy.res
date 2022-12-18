type handler<'target, 'a, 'b> = {get: ('target, string) => (. 'a) => 'b}

@new external make: ({.}, handler<'target, _, _>) => 'target = "Proxy"

/*     return new Proxy({}, { */
/*         get(_, channel: string) { */
/*             return function(payload: any) { */
/*                 client.publish(channel, Json.stringify(payload)); */
/*             }; */
/*         }, */
/*     }) as T; */
