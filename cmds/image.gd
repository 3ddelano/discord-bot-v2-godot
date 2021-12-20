extends Reference

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	# Sends the guild icon
	var guild_id = message.guild_id
	var bytes = yield(bot.get_guild_icon(guild_id), "completed")

	var image = Helpers.to_png_image(bytes)
	var texture = Helpers.to_image_texture(image)

	bot.send(message, {
		"files": [
			{
				"name": "guild.png",
				"media_type": "image/png",
				"data": bytes
			}
		]
	})

func get_usage(p: String) -> String:
	return "`%simage`" % p

var help = {
	"name": "image",
	"category": "General",
	"aliases": ["guild"],
	"enabled": true,
	"description": "Shows the guild icon",
}
