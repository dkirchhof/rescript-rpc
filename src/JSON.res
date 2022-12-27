%%raw(`
  const isoDate = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/

  const reviver = (_key, value) => {
    if (typeof value === "string") {
      const match = isoDate.exec(value);

      if (match) {
        return new Date(value);
      }
    }

    return value;
  };
`)

let encode: 'a => option<string> = %raw(`
  function(value) {
    try {
      return JSON.stringify(value);
    } catch {
      return undefined;
    }
  }
`)

let encodeUnsafe = data => data->encode->Belt.Option.getUnsafe

let decode: string => option<'a> = %raw(`
  function(value) {
    try {
      return JSON.parse(value, reviver);
    } catch {
      return undefined;
    }
  }
`)

let decodeUnsafe = json => json->decode->Belt.Option.getUnsafe
