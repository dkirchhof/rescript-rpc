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

let encode: 'a => string = %raw(`
  function(value) {
    return JSON.stringify(value);
  }
`)

let decode: string => 'a = %raw(`
  function(value) {
    return JSON.parse(value, reviver);
  }
`)
