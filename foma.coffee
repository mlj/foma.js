class FomaNet
  sigmas: []
  maxlen: 0
  finals: []
  transitions: []

  constructor: (json) ->
    @sigmas = json.sigmas

    for s, i in @sigmas when i > 2 # ignore the three first special ones
      @maxlen = s.length if s.length > @maxlen

    arrstate = undefined # keep this state between iterations
    for state in json.states
      unless state[0] == -1
        switch state.length
          when 5
            [arrstate, arrin, arrout, arrtarget, arrfinal] = state
          when 4
            [arrstate, arrin, arrtarget, arrfinal] = state
            arrout = arrin
          when 3
            [arrin, arrout, arrtarget] = state
            arrfinal = null
          when 2
            [arrin, arrtarget] = state
            arrout = arrin
            arrfinal = null
          else
            console.error("Invalid state machine")

        unless arrin == -1
          inputSymbol = @sigmas[arrin]
          @transitions[arrstate] ||= {}
          @transitions[arrstate][inputSymbol] ||= []
          @transitions[arrstate][inputSymbol].push([arrtarget, arrout])

        @finals[arrstate] = true if arrfinal == 1

    @s = {}
    @s[sigma] = i for sigma, i in @sigmas when i >= 3

  resultAccumulator: (s, userData) ->
    userData.push(s)

  applyDown: (s, cb = undefined, userData = undefined, pos = 0, state = 0, outString = "") ->
    unless cb?
      userData = []
      cb = @resultAccumulator

    if @finals[state] and pos is s.length
      cb(outString, userData)

    match = false
    k = @transitions[state]

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
