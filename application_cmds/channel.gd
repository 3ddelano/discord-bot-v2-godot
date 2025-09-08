extends RefCounted

"""
Example command to showcase ApplicationCommand.channel_option()
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	var channel_id = options[0].value
	# print(interaction.data)
	var channel = interaction.data.resolved.channels[channel_id]
	interaction.reply({
		"content": "You selected channel: %s <#%s>" % [channel.name, channel_id]
	})

var data = ApplicationCommand.new()\
	.set_name("channel")\
	.set_description("Example channel option. Set the channel where to send logs.")\
	.add_option(ApplicationCommand.channel_option("channel", "The channel to send logs to.", {
		"required": true,
		"channel_types": ["GUILD_TEXT"] # Only allows text channels in guilds
	}))
