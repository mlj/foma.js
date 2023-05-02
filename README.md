# foma finite-state JS runtime

This is a quick rewrite of the JS runtime for foma finite-state machines. It is
based on the code found in the contrib directory of the foma-0.9.17
distribution but reimplemented to store finite-state machines in JSON (which is
a more compact representation than the original pure JS representation).

The implementation otherwise shares the same key limitations as the original:

> Basic recursive apply down function for Javascript runtime.
> Caveat: does not support flag diacritics and will recurse infinitely
> on input-side epsilon-loops.

## Usage

To convert the foma binary to JSON:

```sh
foma2json test.bin > test.json
```

To apply the machine, do something like this:

```coffee
jsonFetchedHandler = (data) ->
  net = new foma.FST(data)
  console.info(net.applyDown("something"))

$.getJSON('test.json', jsonFetchedHandler)
```

Or with a callback:

```coffee
myHandler = (result, myData) ->

jsonFetchedHandler = (data) ->
  net = new foma.FST(data)
  console.info(net.applyDown("something", myHandler, myData))

$.getJSON('test.json', jsonFetchedHandler)
```

To run the tests, use

```sh
npm run test
```
