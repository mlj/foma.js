# FOMA finite-state JS runtime

This is a quick rewrite of the JS runtime for FOMA finite-state machines. It is
based on the code found in the contrib directory of the foma-0.9.17
distribution but reimplemented to store finite-state machines in JSON (which is
a more compact representation than the original pure JS representation).

The implementation otherwise shares the same key limitations as the original:

> Converts foma file to js array for use with Javascript runtime
> Outputs a js array of all the transitions, indexed in the
> input direction. This array can be passed to the js function
> foma_apply_down() in foma_apply_down.js for stand-alone
> transducer application.
>
> MH 20120127

## Usage

```coffee
cb = (data) ->
  net = new FomaNet(data)
  console.info(net.apply_down("something"))

$.getJSON('test.json', cb)
```
