extends RefCounted
"""
View your bookmarked messages
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, data: Array) -> void:
	var user_id = interaction.member.user.id

	if not main.bookmarks.has(user_id):
		# User doesnt have any bookmarks
		interaction.reply({
			"ephemeral": true,
			"content": "You don't have any bookmarks."
		})
		return

	var bookmarks = []

	var count = 1
	for bookmark in main.bookmarks[user_id].values():
		if bookmark.content == "":
			bookmark.content = "No content"

		bookmarks.append("%s. [%s](%s)" % [count, bookmark.content, bookmark.link])
		count += 1

	interaction.reply({
		"ephemeral": true,
		"embeds": [
			Embed.new().set_title("Your bookmarks")\
				.set_color("#e6e63e")\
				.set_description("\n".join(PackedStringArray(bookmarks)))
		]
	})

var data = ApplicationCommand.new()\
	.set_name("bookmarks")\
	.set_description("View your saved bookmarks")
