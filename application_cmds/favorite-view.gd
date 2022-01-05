extends Reference
"""
View your favorite users
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, data: Array) -> void:
	var user_id = interaction.member.user.id

	if not main.favorites.has(user_id):
		# User doesnt have any favorites
		interaction.reply({
			"ephemeral": true,
			"content": "You don't have any favorites."
		})
		return

	var favorites = []

	var count = 1
	for favorite in main.favorites[user_id].values():
		favorites.append("%s. <@%s>" % [count, favorite.id])
		count += 1

	interaction.reply({
		"ephemeral": true,
		"embeds": [
			Embed.new().set_title("Your favorites")\
				.set_color("#e6e63e")\
				.set_description(PoolStringArray(favorites).join("\n"))
		],
		# This prevents pinging all the users who are in favorites
		"allowed_mentions": {
			"parse": []
		}
	})


var data = ApplicationCommand.new()\
	.set_name("favorites")\
	.set_description("View your saved favorites")
