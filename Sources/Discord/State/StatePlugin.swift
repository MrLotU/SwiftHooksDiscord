fileprivate extension DiscordGatewayType where Self: DiscordHandled {
    var state: State {
        self.client.state
    }
}

class StatePlugin: Plugin {
    
    var listeners: some EventListeners {
        Listeners {
            Listeners {
                Listener(Discord.ready) { _, ready -> Void in
                    let user = ready.user
                    user.client = ready.client
                    ready.state.me = user
                }
                
                Listener(Discord.guildCreate) { _, guild -> Void in
                    guild.state.guilds[guild.id] = guild
                    guild.channels.forEach {
                        guild.state.channels[$0.id] = $0
                    }
                    guild.members.forEach {
                        if let u = $0.user {
                            guild.state.users[u.id] = u
                        }
                    }
                }
                
                Listener(Discord.guildUpdate) { _, update -> Void in }
                
                Listener(Discord.guildDelete) { _, event -> Void in
                    guard let guild = event.state.guilds[event.id] else { return }
                    for c in guild.channels {
                        event.state.channels[c.id] = nil
                    }
                    event.state.guilds[event.id] = nil
                }
                
                Listener(Discord.channelCreate) { _, channel -> Void in
                    channel.state.channels[channel.id] = channel
                    if channel.isGuild, let guildId = channel.guildId, let guild = channel.state.guilds[guildId] {
                        guild.channels[channel.id] = channel
                    } else if channel.isDm {
                        channel.state.dms[channel.id] = channel
                    }
                }
                
                Listener(Discord.channelUpdate) { _, channelUpdate -> Void in }
                
                Listener(Discord.channelDelete) { _, channel -> Void in
                    channel.state.channels[channel.id] = nil
                    if channel.isGuild, let guildId = channel.guildId, let guild = channel.state.guilds[guildId] {
                        guild.channels[channel.id] = nil
                    } else if channel.isDm {
                        channel.state.dms[channel.id] = nil
                    }
                }
                
                Listener(Discord.guildMemberAdd) { _, member -> Void in
                    member.state.users[member.user.id] = member.user
            
                    if let id = member.guildId, let guild = member.state.guilds[id] {
                        guild.members.append(member)
                    }
                }
                
                Listener(Discord.guildMemberUpdate) { _, guildMemberUpdate -> Void in }
                
                Listener(Discord.guildMembersChunk) { _, chunk -> Void in
                    guard let guild = chunk.state.guilds[chunk.guildId] else { return }
                    for mem in chunk.members {
                        mem.guildId = guild.id
                        guild.members[mem.user.id] = mem
            
                        chunk.state.users[mem.user.id] = mem.user
                    }
                }
            }
            Listeners {
                Listener(Discord.guildRoleCreate) { _, event -> Void in
                    guard let guild = event.state.guilds[event.guildId] else { return }
                    guild.roles[event.role.id] = event.role
                }
                
                Listener(Discord.guildRoleUpdate) { _, guildRoleUpdate -> Void in }
                
                Listener(Discord.guildRoleDelete) { _, event -> Void in
                    guard let guild = event.state.guilds[event.guildId], guild.roles.sContains(event.roleId) else { return }
                    guild.roles[event.roleId] = nil
                }
                
                Listener(Discord.guildEmojisUpdate) { _, event -> Void in
                    guard let guild = event.state.guilds[event.guildId] else { return }
                    guild.emojis = event.emojis
                }
                
                Listener(Discord.presenceUpdate) { _, presenceUpdate -> Void in }
            }
        }
    }
}
