type t = {
  echo: (. string) => promise<string>,
  ping: (. unit) => promise<string>,
  add: (. int, int) => promise<int>,
}
