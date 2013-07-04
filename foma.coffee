window.foma_apply_down = (net, s) ->
  foma_apply_dn net, s, 0, 0, "", new Array

foma_apply_dn = (net, s, pos, state, outString, reply) ->
  if net.f[state] is 1 and pos is s.length
    reply.push outString

  match = false
  len = 0

  while len <= net.maxlen and len <= s.length - pos
    key = "#{state}|#{s.substr(pos, len)}"
    for key2, value2 of net.t[key]
      for targetState, outputSymbol of value2
        return unless targetState?
        match = true
        outputSymbol = "?" if outputSymbol is "@UN@"
        foma_apply_dn net, s, pos + len, targetState, outString + outputSymbol, reply
    len++

  if match and not net.s[s.substr(pos, 1)]? and s.length > pos
    key = "#{state}|@ID@"
    for key2, value2 of net.t[key]
      for targetState, outputSymbol of value
        return unless targetState?
        outputSymbol = "?" if outputSymbol is "@UN@"
        outputSymbol = s.substr(pos, 1) if outputSymbol is "@ID@"
        foma_apply_dn net, s, pos + 1, targetState, outString + outputSymbol, reply

  reply
