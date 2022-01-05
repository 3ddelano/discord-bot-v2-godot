extends Reference
"""
Example command to showcase using MessageButton
"""

func on_ready(main, bot: DiscordBot):
	main.connect("interaction_create", self, "on_interaction")

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	# Shows some buttons
	var button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
	button.set_custom_id("my_custom_button").set_label("Click Me")

	var button2 = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
	button2.set_custom_id("my_custom_button2").set_label("Do not Click Me")

	var row = MessageActionRow.new()
	var row2 = MessageActionRow.new()

	row.add_component(button)
	row2.add_component(button2)

	var msg = yield(bot.send(message, {
		"content": "Here's some buttons",
		"components": [row, row2]
	}), "completed")

	# Cache the message with buttons
	main.interactions[msg.id] = {
		"author_id": message.author.id,
	}

func on_interaction(main, bot: DiscordBot, interaction: DiscordInteraction, data: Dictionary) -> void:
	if not interaction.is_button():
		return

	var custom_id = interaction.data.custom_id
	match custom_id:
		"my_custom_button":
			interaction.reply({
				"content": "You clicked the button"
			})

		"my_custom_button2":
			interaction.reply({
				"content": "Why did you click this?"
			})

func get_usage(p: String) -> String:
	return "`%sbutton`" % p

var help = {
	"name": "button",
	"category": "Button",
	"aliases": [],
	"enabled": true,
	"description": "Sends some buttons",
}
