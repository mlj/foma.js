resultHandler = (s, results) ->
  results.push(s)

jsonFetchedHandler = (data) ->
  net = new window.FomaNet(data)
  window.net = net

  console.info("Applying OK w/cb")
  results = []
  console.info(net.applyDown("amō+VERB+ger+acc", resultHandler, results))

  console.info("Applying OK no CB")
  results = []
  console.info(net.applyDown("amō+VERB+ger+acc"))

  console.info("Applying not OK w/cb")
  results = []
  console.info(net.applyDown("shouldfail", resultHandler, results))

  console.info("Applying not OK no CB")
  results = []
  console.info(net.applyDown("shouldfail"))

console.info("Fetching JSON...")
$.getJSON('test.json', jsonFetchedHandler)
