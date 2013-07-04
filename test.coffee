cb = (data) ->
  net = new window.FomaNet(data)
  window.net = net

  console.info("Applying")
  console.info(net.apply_down("amō+VERB+ger+acc"))
  console.info(net.apply_down("amō+VERB+ger+acc"))

console.info("Fetching JSON...")
$.getJSON('test.json', cb)
