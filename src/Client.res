let make: string => 'a = %raw(`
  function(encode, decode, endpoint) {
    return new Proxy({}, {
      get: (_, p) => {
        return async function(...params) {
          const body = encode({
            procedure: p,
            params,
          });
 
          const response = await fetch(endpoint, {
            method: "POST",
            body,
          });

          const json = await response.text();

          return decode(json);
        };
      },
    });
  }
`)(JSON.encode, JSON.decode)
