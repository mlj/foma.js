class FomaNet
  constructor: (json) ->
    @maxlen = json.maxlen

    @f = {}
    @f[final] = true for final in json.finals

    @s = {}
    @s[sigma] = i for sigma, i in json.sigmas when i >= 3

    @t = {}

    for state, v1 of json.transitions
      @t[state] = {}
      for inputSymbolId, v2 of v1
        inputSymbol = json.sigmas[inputSymbolId]
        @t[state][inputSymbol] = []
        for v3 in v2
          for targetState, outputSymbolId of v3
            outputSymbol = json.sigmas[outputSymbolId]
            k = {}
            k[targetState] = outputSymbol
            @t[state][inputSymbol].push(k)

  resultAccumulator: (s, userData) ->
    userData.push(s)

  applyDown: (s, cb = undefined, userData = undefined, pos = 0, state = 0, outString = "") ->
    unless cb?
      userData = []
      cb = @resultAccumulator

    if @f[state] and pos is s.length
      cb(outString, userData)

    match = false
    k = @t[state]

    if k?
      for len in [0..Math.min(@maxlen, s.length - pos)]
        f = k["#{s.substr(pos, len)}"]
        if f?
          for value2 in f
            for targetState, outputSymbol of value2
              return match unless targetState?
              match = true
              outputSymbol = "?" if outputSymbol is "@UN@"
              @applyDown s, cb, userData, pos + len, targetState, outString + outputSymbol

      if match and not @s[s.substr(pos, 1)]? and s.length > pos
        f = k["@ID@"]
        if f?
          for value2 in f
            for targetState, outputSymbol of value
              return match unless targetState?
              outputSymbol = "?" if outputSymbol is "@UN@"
              outputSymbol = s.substr(pos, 1) if outputSymbol is "@ID@"
              @applyDown s, cb, userData, pos + 1, targetState, outString + outputSymbol

    userData

window.FomaNet = FomaNet
