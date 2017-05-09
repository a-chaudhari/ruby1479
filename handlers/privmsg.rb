def privmsg(chunks, raw)
  target = chunks[2]

  if target == @nickname
    handle_query(chunks, raw)
  else
    chan = @channels[target]
    user_str = chunks[0]
    user = user_str.split('!', 2).first
    msg = chunks.drop(3).join(' ')

    command = { user: user,
                channel: chan.channel,
                user_str: user_str,
                msg: msg,
                timestamp: Time.now }

    chan._recv(:chanmsg, command)
  end
end

def handle_query(chunks, raw)
  user_str = chunks[0]
  msg = chunks.drop(3).join(' ')
  user = user_str.split('!', 2).first

  command = { user: user,
              user_str: user_str,
              msg: msg,
              timestamp: Time.now }

  emit(:query, command)
end
