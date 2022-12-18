type t = {
  echo: string => promise<string>,
  ping: () => promise<string>
}
