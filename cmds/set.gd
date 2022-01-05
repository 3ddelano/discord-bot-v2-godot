extends Reference
"""
Example command showcasing nested SelectMenu
"""

var flows = {
	"set": {
		"title": "Choose an action from the menu",
		"color": "#73c6f0",
		"select_menu": SelectMenu.new().set_custom_id("set").set_placeholder("Choose an option").add_option("country", "Country", {"description": "Set your country"}).add_option("language", "Language(s)", {"description": "Set your language(s)"})
	},
	"country": {
		"title": "Which country are you from?",
		"color": "#f07373",
		"select_menu":
			SelectMenu.new().set_custom_id("set-country").set_placeholder("Choose a country").add_option("japan", "Japan").add_option("canada", "Canada").add_option("india", "India").add_option("usa", "USA").add_option("uk", "UK").add_option("germany", "Germany").add_option("australia", "Australia").add_option("new-zealand", "New Zealand")
	},
	"language": {
		"title": "What is your preferred language(s)?",
		"color": "#eaf073",
		"select_menu":
			SelectMenu.new().set_custom_id("set-language").set_placeholder("Choose one or more languages").set_max_values(7).add_option("english", "English").add_option("hindi", "Hindi").add_option("spanish", "Spanish").add_option("french", "French").add_option("portuguese", "Portuguese").add_option("japanese", "Japanese").add_option("chinese", "Chinese")
	}
}

func on_ready(main, bot: DiscordBot):
	main.connect("interaction_create", self, "on_interaction")

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	# Store various important data for this interaction
	var data = {
		"author_id": message.author.id,
		"author_tag": message.author.username + "#" + message.author.discriminator,
		"flow_name": "set"
	}

	var msg = yield(bot.send(message, _make_message(data)), "completed")
	# Cache this in the interactions
	main.interactions[msg.id] = data

func _make_message(data) -> Dictionary:
	var flow = flows[data.flow_name]
	var row = MessageActionRow.new().add_component(flow.select_menu)

	# The message will have one embed and one menu,
	# the data for the embed and menu is based on which flow the user is on
	return {
		"embeds": [
			Embed.new().set_title(flow.title).set_color(flow.color).set_footer("Requested by " + data.author_tag)
		],
		"components": [row]
	}

func on_interaction(main, bot: DiscordBot, interaction: DiscordInteraction, data: Dictionary) -> void:
	if not interaction.is_select_menu():
		return

	var custom_id = interaction.data.custom_id
	var value = interaction.data.values[0]
	var msg_id = interaction.message.id

	# Handle each flow interaction
	match custom_id:
		"set":
			# Here we update the flow to whichever the user chose
			main.interactions[msg_id].flow_name = value
			yield(interaction.update(_make_message(main.interactions[msg_id])), "completed")

		"set-country":
			yield(interaction.update({
				"content": ":white_check_mark: Your country was updated to: `" + value + "`",
				"embeds": [],
				"components": []
			}), "completed")

		"set-language":
			yield(interaction.update({
				"content": ":white_check_mark: Your languages was updated to: `" + PoolStringArray(interaction.data.values).join("`, `") + "`",
				"embeds": [],
				"components": []
			}), "completed")

func get_usage(p: String) -> String:
	return "`%sset`" % p

var help = {
	"name": "set",
	"category": "Menu",
	"aliases": [],
	"enabled": true,
	"description": "Command showcasing nested menus",
}
