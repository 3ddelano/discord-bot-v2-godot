extends Reference
"""
A navigable embed based on Embed and MessageButton
"""

var pages_data = [
	{
		"title": "Hello Page 1",
		"description": "Example description for page 1. Lorem ipsum dolor sit amet.",
		"color": "#ff0000"
	},
	{
		"title": "Hi Page 2 here",
		"description": "Description of page 2 goes here. Lorem ipsum dolor sit amet.",
		"color": "#00ff00"
	},
	{
		"title": "Page 3 Title",
		"description": "Page 3's description is here. Lorem ipsum dolor sit amet.",
		"color": "#0000ff"
	}
]

var buttons = {
	"nav_prev": MessageButton.new().set_style(MessageButton.STYLES.SECONDARY).set_label("Prev").set_custom_id("nav_prev"),
	"nav_prev_dis": MessageButton.new().set_style(MessageButton.STYLES.SECONDARY).set_label("Prev").set_custom_id("nav_prev_dis").set_disabled(true),
	"nav_next": MessageButton.new().set_style(MessageButton.STYLES.SECONDARY).set_label("Next").set_custom_id("nav_next"),
	"nav_next_dis": MessageButton.new().set_style(MessageButton.STYLES.SECONDARY).set_label("Next").set_custom_id("nav_next_dis").set_disabled(true),
}

func on_ready(main, bot: DiscordBot):
	main.connect("interaction_create", self, "on_interaction")

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	var uid = message.author.id
	var tag = message.author.username + "#" + message.author.discriminator

	var data = {
		"author_id": uid,
		"author_tag": tag,
		"page_idx": 0
	}
	var msg = yield(bot.reply(message, _make_embed(data)), "completed")
	main.interactions[msg.id] = data

func _make_embed(data: Dictionary) -> Dictionary:
	var page_data = pages_data[data.page_idx]
	var embed = Embed.new().set_title(page_data.title).set_timestamp().set_footer(str(data.page_idx + 1) + "/" + str(pages_data.size()) + " | Requested by " + data.author_tag).set_color(page_data.color)
	embed.set_description(page_data.description)

	var actual_row = MessageActionRow.new()

	if data.page_idx == 0:
		actual_row.add_component(buttons.nav_prev_dis) # Disable previous button
	else:
		actual_row.add_component(buttons.nav_prev)

	if data.page_idx == pages_data.size() - 1:
		actual_row.add_component(buttons.nav_next_dis) # Disable next button
	else:
		actual_row.add_component(buttons.nav_next)

	return {
		"embeds": [embed],
		"components": [actual_row],
		"attachments": []
	}

func on_interaction(main, bot: DiscordBot, interaction: DiscordInteraction, data: Dictionary) -> void:
	if not interaction.is_button():
		return

	var msg_id = interaction.message.id
	var custom_id = interaction.data.custom_id

	if custom_id == "nav_prev":
		main.interactions[msg_id].page_idx -= 1
		interaction.update(_make_embed(data))
	elif custom_id == "nav_next":
		main.interactions[msg_id].page_idx += 1
		interaction.update(_make_embed(data))

func get_usage(p: String) -> String:
	return "`%snav`" % p

var help = {
	"name": "nav",
	"category": "Button",
	"aliases": [],
	"enabled": true,
	"description": "Sends a navigable embed",
}
