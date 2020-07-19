const FST = (function() {
  FST.prototype.sigmas = [];
  FST.prototype.maxlen = 0;
  FST.prototype.finals = [];
  FST.prototype.transitions = [];

  function FST(json) {
    if (json)
      this.load(json);
  }

  FST.prototype.load = function(json) {
    // Grab sigmas
    this.sigmas = json.sigmas;

    // Compute maxlen but ignore the three first special ones
    this.maxlen = Math.max.apply(null, this.sigmas.slice(3).map(s => s.length));

    var arrstate = void 0; // keep between iterations

    json.states.forEach(state => {
      var arr = {
        final: null,
        in: null,
        out: null,
        target: null
      };

      if (state[0] !== -1) {
        switch (state.length) {
          case 5:
            arrstate = state[0];

            arr.in = state[1];
            arr.out = state[2];
            arr.target = state[3];
            arr.final = state[4];
            break;

          case 4:
            arrstate = state[0];

            arr.in = arr.out = state[1];
            arr.target = state[2];
            arr.final = state[3];
            break;

          case 3:
            arr.in = state[0];
            arr.out = state[1];
            arr.target = state[2];
            arr.final = null;
            break;

          case 2:
            arr.in = arr.out = state[0];
            arr.target = state[1];
            arr.final = null;
            break;

          default:
            // console.error("Invalid state machine");
        }

        if (arr.in !== -1) {
          let a = this.transitions;
          a[arrstate] || (a[arrstate] = {});

          let b = this.transitions[arrstate];
          let inputSymbol = this.sigmas[arr.in];
          b[inputSymbol] || (b[inputSymbol] = []);

          b[inputSymbol].push([arr.target, arr.out]);
        }

        if (arr.final === 1)
          this.finals[arrstate] = true;
      }
    });

    this.s = {};

    for (let i = 3; i < this.sigmas.length; ++i) {
      this.s[this.sigmas[i]] = i;
    }
  };

  FST.prototype.applyDownSync = function(s) {
    let buffer = [];
    this.applyDownAsync(s, t => buffer.push(t));
    return buffer;
  };

  FST.prototype.applyDownAsync = function(s, cb) {
    let context = {
      s: s,
      cb: cb
    };
    return this._applyDown(0, 0, "", context);
  }

  FST.prototype._applyDown = function(pos, state, outString, context) {
    if (context.cb && this.finals[state] && pos === context.s.length)
      context.cb(outString);

    var match = false;

    if (this.transitions[state] != null) {
      // TODO: Is there a trap here? If pos > s.length, we get a negative number
      var ref = Math.min(this.maxlen, context.s.length - pos);

      for (var len = 0; len <= ref; len++) {
        let f = this.transitions[state][context.s.substr(pos, len)];

        if (f != null) {
          for (let i = 0; i < f.length; i++) {
            if (this._next(pos, len, f, i, outString, context))
              return match;
            else
              match = true;
          }
        }
      }

      if (match && (this.s[context.s.substr(pos, 1)] == null) && context.s.length > pos) {
        let f = this.transitions[state]["@ID@"];

        if (f != null) {
          for (let i = 0; i < f.length; i++) {
            if (this._next(pos, 1, f, i, outString, context))
              return match;
          }
        }
      }
    }

    return match;
  };

  FST.prototype._next = function(pos, len, f, i, outString, context) {
    var v = f[i];
    var target = v[0], out = v[1];

    if (target == null)
      return true;
    else {
      var s = this._readOutput(out, context.s, pos);
      this._applyDown(pos + len, target, outString + s, context);
      return false;
    }
  };

  FST.prototype._readOutput = function(id, s, pos) {
    var outputSymbol = this.sigmas[id];

    if (outputSymbol === "@UN@")
      return "?";
    else if (outputSymbol === "@ID@")
      return s.substr(pos, 1);
    else
      return outputSymbol;
  };

  return FST;
})();

export default FST;