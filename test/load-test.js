var tape = require("tape"),
    fs = require('fs'),
    foma = require("../");

tape("foma-fst successfully generates", function(test) {
  var data = JSON.parse(fs.readFileSync('test/test.json', 'utf8'));
  var net = new foma.FST(data);
  var r = net.applyDownSync("foobar");

  test.deepEqual(r, ['foo', 'bar']);
  test.end();
});

tape("foma-fst fails to generate", function(test) {
  var data = JSON.parse(fs.readFileSync('test/test.json', 'utf8'));
  var net = new foma.FST(data);
  var r = net.applyDownSync("foobarx");

  test.deepEqual(r, []);
  test.end();
});
