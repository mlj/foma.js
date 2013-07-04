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
cb = (data) ->
  net = new FomaNet(data)
  console.info(net.apply_down("something"))

$.getJSON('test.json', cb)
```

## Dependencies

None
