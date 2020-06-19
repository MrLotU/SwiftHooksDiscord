fileprivate extension DiscordGatewayType where Self: DiscordHandled {
    var state: State {
        self.client.state
    }
}

class StatePlugin: Plugin {
    
    var listeners: some EventListeners {
        Listeners {
            Listeners {
                Listener(Discord.ready) { e, ready -> Void in
                    let user = ready.user
                    user.client = ready.client
                    e.state.me = user
                }
                
                Listener(Discord.guildCreate) { e, guild -> Void in
                    guild.state.guilds[guild.id] = guild
                    guild.channels.forEach {
                        $0.guildId = guild.id
                        e.state.channels[$0.id] = $0
                    }
                    guild.members.forEach {
                        if let u = $0.user {
                            e.state.users[u.id] = u
                        }
                    }
                }
                
                Listener(Discord.guildUpdate) { _, update -> Void in }
                
                Listener(Discord.guildDelete) { e, event -> Void in
                    guard let guild = e.state.guilds[event.id] else { return }
                    for c in guild.channels {
                        e.state.channels[c.id] = nil
                    }
                    e.state.guilds[event.id] = nil
                }
                
                Listener(Discord.channelCreate) { e, channel -> Void in
                    e.state.channels[channel.id] = channel
                    if channel.isGuild, let guildId = channel.guildId, let guild = e.state.guilds[guildId] {
                        guild.channels[channel.id] = channel
                    } else if channel.isDm {
                        e.state.dms[channel.id] = channel
                    }
                }
                
                Listener(Discord.channelUpdate) { _, channelUpdate -> Void in }
                
                Listener(Discord.channelDelete) { e, channel -> Void in
                    e.state.channels[channel.id] = nil
                    if channel.isGuild, let guildId = channel.guildId, let guild = e.state.guilds[guildId] {
                        guild.channels[channel.id] = nil
                    } else if channel.isDm {
                        e.state.dms[channel.id] = nil
                    }
                }
                
                Listener(Discord.guildMemberAdd) { e, member -> Void in
                    if let u = e.state.users[member.user.id] {
                        member.user = u
                    } else {
                        e.state.users[member.user.id] = member.user
                    }
            
                    if let id = member.guildId, let guild = member.state.guilds[id] {
                        guild.members.append(member)
                    }
                }
                
                Listener(Discord.guildMemberUpdate) { _, guildMemberUpdate -> Void in }
                
                Listener(Discord.guildMembersChunk) { e, chunk -> Void in
                    guard let guild = e.state.guilds[chunk.guildId] else { return }
                    for mem in chunk.members {
                        mem.guildId = guild.id
                        guild.members[mem.user.id] = mem
            
                        e.state.users[mem.user.id] = mem.user
                    }
                }
            }
            Listeners {
                Listener(Discord.guildMemberRemove) { e, event -> Void in
                    if let g = e.state.guilds[event.guildId] {
                        g.members[event.user.id] = nil
                    }
                }
                
                Listener(Discord.messageCreate) { e, message -> Void in
                    if let c = e.state.channels[message.channelId] {
                        c.lastMessageId = message.id
                    }
                }
                
                Listener(Discord.guildRoleCreate) { e, event -> Void in
                    guard let guild = e.state.guilds[event.guildId] else { return }
                    guild.roles[event.role.id] = event.role
                }
                
                Listener(Discord.guildRoleUpdate) { _, guildRoleUpdate -> Void in }
                
                Listener(Discord.guildRoleDelete) { e, event -> Void in
                    guard let guild = e.state.guilds[event.guildId], guild.roles.sContains(event.roleId) else { return }
                    guild.roles[event.roleId] = nil
                }
                
                Listener(Discord.guildEmojisUpdate) { e, event -> Void in
                    guard let guild = e.state.guilds[event.guildId] else { return }
                    guild.emojis = event.emojis
                }
                
                Listener(Discord.presenceUpdate) { _, presenceUpdate -> Void in }
            }
        }
    }
}
