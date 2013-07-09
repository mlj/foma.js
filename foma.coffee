class FomaNet
  constructor: (json) ->
    @finals = {}
    @finals[final] = true for final in json.finals

    @sigmas = json.sigmas

    @maxlen = 0

    for s, i in @sigmas when i > 2
      @maxlen = s.length if s.length > @maxlen

    @s = {}
    @s[sigma] = i for sigma, i in @sigmas when i >= 3

    @t = []

    for v1, state in json.transitions
      @t[state] = {}
      for inputSymbolId, v2 of v1
        inputSymbol = @sigmas[inputSymbolId]
        @t[state][inputSymbol] = v2

  resultAccumulator: (s, userData) ->
    userData.push(s)

  applyDown: (s, cb = undefined, userData = undefined, pos = 0, state = 0, outString = "") ->
    unless cb?
      userData = []
      cb = @resultAccumulator

    if @finals[state] and pos is s.length
      cb(outString, userData)

    match = false
    k = @t[state]

    if k?
      for len in [0..Math.min(@maxlen, s.length - pos)]
        f = k["#{s.substr(pos, len)}"]
        if f?
          for value2 in f
            [targetState, outputSymbolId] = value2
            return match unless targetState?
            match = true
            outputSymbol = @sigmas[outputSymbolId]
            outputSymbol = "?" if outputSymbol is "@UN@"
            @applyDown s, cb, userData, pos + len, targetState, outString + outputSymbol

      if match and not @s[s.substr(pos, 1)]? and s.length > pos
        f = k["@ID@"]
        if f?
          for value2 in f
            [targetState, outputSymbolId] = value2
            return match unless targetState?
            outputSymbol = @sigmas[outputSymbolId]
            outputSymbol = "?" if outputSymbol is "@UN@"
            outputSymbol = s.substr(pos, 1) if outputSymbol is "@ID@"
            @applyDown s, cb, userData, pos + 1, targetState, outString + outputSymbol

    userData

window.FomaNet = FomaNet
