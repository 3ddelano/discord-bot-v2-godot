extends Reference
"""
Mark any user as a favorite
Steps
1. Right-click on a user and click Apps
2. Click on the `Add to Favorites` option

To view favorties use `/favorites`
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	# The ID of the user who used this command
	var author_id = interaction.member.user.id
	# The ID of the user on whom the command was used
	var user_id = interaction.data.target_id
	var user = User.new(bot, interaction.data.resolved.users[user_id])
	#print(user)

	if not main.favorites.has(author_id):
		# Keep cache of user's favorites
		main.favorites[author_id] = {}

	if not main.favorites[author_id].has(user_id):
		# Add this message to the user's favorites
		main.favorites[author_id][user_id] = {
			"id": user_id
		}

		interaction.reply({
			"ephemeral": true,
			"content": "User was added to favorites!"
		})
	else:
		# If the user is already in favorites, dont do anything
		interaction.reply({
			"ephemeral": true,
			"content": "User is already in favorites!"
		})


var data = ApplicationCommand.new()\
	.set_name("Add to Favorites")\
	.set_type("USER")
