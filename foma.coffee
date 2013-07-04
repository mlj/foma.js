class FomaNet
  constructor: (json) ->
    @maxlen = json.maxlen

    @t = json.transitions

    @f = {}
    @f[final] = true for final in json.finals

    @s = {}
    @s[sigma] = i for sigma, i in json.sigmas when i >= 3

  apply_down: (s) ->
    @reply = []
    @foma_apply_dn(s, 0, 0, "")
    @reply

  foma_apply_dn: (s, pos, state, outString) ->
    if @f[state] and pos is s.length
      @reply.push outString

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
              @foma_apply_dn s, pos + len, targetState, outString + outputSymbol

      if match and not @s[s.substr(pos, 1)]? and s.length > pos
        f = k["@ID@"]
        if f?
          for value2 in f
            for targetState, outputSymbol of value
              return match unless targetState?
              outputSymbol = "?" if outputSymbol is "@UN@"
              outputSymbol = s.substr(pos, 1) if outputSymbol is "@ID@"
              @foma_apply_dn s, pos + 1, targetState, outString + outputSymbol

    match

window.FomaNet = FomaNet
