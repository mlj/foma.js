window.foma_apply_down = (net, s) ->
  foma_apply_dn net, s, 0, 0, "", new Array

foma_apply_dn = (net, s, pos, state, outString, reply) ->
  if net.f[state] is 1 and pos is s.length
    reply.push outString

  match = 0
  len = 0

  while len <= net.maxlen and len <= s.length - pos
    key = state + "|" + s.substr(pos, len)
    for key2 of net.t[key]
      for targetState of net.t[key][key2]
        return unless targetState?
        outputSymbol = net.t[key][key2][targetState]
        match = 1
        outputSymbol = "?" if outputSymbol is "@UN@"
        foma_apply_dn net, s, pos + len, targetState, outString + outputSymbol, reply
    len++

  if match is 0 and not net.s[s.substr(pos, 1)]? and s.length > pos
    key = state + "|" + "@ID@"
    for key2 of net.t[key]
      for targetState of net.t[key][key2]
        return unless targetState?
        outputSymbol = net.t[key][key2][targetState]
        outputSymbol = "?" if outputSymbol is "@UN@"
        outputSymbol = s.substr(pos, 1) if outputSymbol is "@ID@"
        foma_apply_dn net, s, pos + 1, targetState, outString + outputSymbol, reply

  reply
