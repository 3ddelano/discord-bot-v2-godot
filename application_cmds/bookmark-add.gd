extends RefCounted
"""
Mark any message as a bookmark
Steps
1. Right-click on a message and click Apps
2. Click on the `Add to Bookmarks` option

To view bookmarks use `/bookmarks`
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	# The ID of the user who used this command
	var author_id = interaction.member.user.id
	# The ID of the message on which this command was used
	var msg_id = interaction.data.target_id
	var message = interaction.data.resolved.messages[msg_id]
	#print(message)

	var link = "https://discord.com/channels/%s/%s/%s" % [interaction.guild_id, message.channel_id, message.id]

	if not main.bookmarks.has(author_id):
		# Keep cache of user's bookmarks
		main.bookmarks[author_id] = {}

	if not main.bookmarks[author_id].has(msg_id):
		# Add this message to the user's bookmarks
		main.bookmarks[author_id][msg_id] = {
			"content": message.content,
			"link": link
		}

		interaction.reply({
			"ephemeral": true,
			"content": "Bookmark added!"
		})
	else:
		# If the message is already bookmarked, dont do anything
		interaction.reply({
			"ephemeral": true,
			"content": "Message is already bookmarked!"
		})


var data = ApplicationCommand.new()\
	.set_name("Add to Bookmarks")\
	.set_type("MESSAGE")
