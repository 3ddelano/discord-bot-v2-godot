extends RefCounted
"""
Example command to showcase using Embed
"""

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	# Sends an embed
	var embed1 = Embed.new().set_description("First Embed").set_color("#ff0000")
	var embed2 = Embed.new().set_description("Second Embed").set_color("#00ff00")

	bot.send(message, 'Content here too', {
		"embeds": [embed1, embed2]
	})

func get_usage(p: String) -> String:
	return "`%sembed`" % p

var help = {
	"name": "embed",
	"category": "General",
	"aliases": [],
	"enabled": true,
	"description": "Sends some embeds",
}
