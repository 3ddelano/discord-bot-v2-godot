extends RefCounted
"""
Sends your or the mentioned user's avatar
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	var user: User = null

	if options.is_empty():
		# Shows the user's avatar
		user = interaction.member.user
	else:
		# Shows the mentioned user's avatar
		var user_id = options[0].value
		user = User.new(bot, interaction.data.resolved.users[user_id])

	var avatar_url = user.get_display_avatar_url()
	interaction.reply({
		"ephemeral": true,
		"embeds": [
			Embed.new().set_title(user.username + "#" + user.discriminator + "'s Avatar").set_image(avatar_url).set_timestamp()
		]
	})

var data = ApplicationCommand.new()\
	.set_name("avatar")\
	.set_description("Sends your or the mentioned user's avatar")\
	.add_option(ApplicationCommand.user_option("user", "Mention any user"))
