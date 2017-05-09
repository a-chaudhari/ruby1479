def ERR_NICKNAMEINUSE(chunks, raw)
  @nickname += '_'
  self.write("NICK #{@nickname}")
  emit(:self_new_nickname, @nickname)
end

def NICK(chunks, raw)
  old_nick = chunks[0].split('!', 2).first
  new_nick = chunks[2]
  command = {
    from: old_nick,
    to: new_nick
  }
  if old_nick == @nickname
    @nickname = new_nick
    emit(:self_new_nickname, command)
  else
    @channels.values.each do |chan|
      users = chan.users
      if users.include?(old_nick)
        users.delete(old_nick)
        users.add(new_nick)
        #TODO handle nicks with status symbols
      end
      chan._recv(:userlist_changed)
      chan._recv(:new_nickname, command)
    end
  end
end
